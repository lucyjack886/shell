#!/bin/bash

# 证书配置文件
cat > openssl.cnf << EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
C = GB
ST = Greater Manchester
L = Salford
O = Sectigo Limited
CN = ithome.com

[v3_req]
subjectAltName = DNS:ithome.com,DNS:www.ithome.com
basicConstraints = CA:FALSE
keyUsage = digitalSignature,keyEncipherment
extendedKeyUsage = serverAuth
authorityInfoAccess = OCSP;URI:http://ocsp.sectigo.com
certificatePolicies = 1.3.6.1.4.1.6449.1.2.2.52
crlDistributionPoints = URI:http://crl.sectigo.com/SectigoRSADomainValidationSecureServerCA.crl
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
EOF


# 生成自签名证书
openssl req -x509 -newkey rsa:2048 -nodes -keyout private.key -out cert.pem -days 365 -config openssl.cnf


# 获取NodeID
while true; do
    read -p "请输入NodeID: " NODE_ID
    if [[ $NODE_ID =~ ^[0-9]+$ ]]; then
        break
    else
        echo "无效输入，请输入一个有效的数字。"
    fi
done

echo "你输入的NodeID是: $NODE_ID"

# 检查并安装 wget 和 unzip
install_dependencies() {
    if [[ "$OS_NAME" == "centos" ]]; then
        sudo yum install -y wget unzip sudo net-tools
    elif [[ "$OS_NAME" == "debian" || "$OS_NAME" == "ubuntu" ]]; then
        sudo apt update
        sudo apt install -y wget unzip sudo net-tools
    else
        echo "Unsupported OS: $OS_NAME"
        exit 1
    fi
}

# 获取操作系统的名字
OS_NAME=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')

# 检查并安装 unzip（如果没有安装的话）
if ! command -v unzip &> /dev/null; then
    install_dependencies
fi

# 创建目录并进入
cd /root
mkdir -p V2bX
cd V2bX

# 获取系统架构
ARCH=$(uname -m)

# 根据系统架构下载并解压相应的文件
if [ "$ARCH" == "x86_64" ]; then
    echo "Detected x86_64 architecture."
    wget https://github.com/wyx2685/V2bX/releases/download/v0.2.5/V2bX-linux-64.zip
    unzip V2bX-linux-64.zip    
elif [[ "$ARCH" == arm* || "$ARCH" == aarch* ]]; then
    echo "Detected ARM architecture."
    wget https://github.com/wyx2685/V2bX/releases/download/v0.2.5/V2bX-linux-arm64-v8a.zip
    unzip V2bX-linux-arm64-v8a.zip
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi


# 创建配置文件 sing_origin.json
cat <<EOF > /root/V2bX/sing_origin.json
{
    "outbounds": [
        {
            "tag": "direct",
            "type": "direct",
            "domain_strategy": "ipv4_only"
        }
    ],
    "route": {
        "rules": [
            {
                "outbound": "direct",
                "network": [
                    "udp",
                    "tcp"
                ]
            }
        ]
    },
    "experimental": {
        "cache_file": {
            "enabled": true
        }
    }
}
EOF


# 创建配置文件 config.yml
cat <<EOF > /root/V2bX/trojan.yml
{
  "Log": {
    "Level": "info",
    "Output": ""
  },
  "Cores": [
    {
      "Type": "sing",
      "Log": {
        "Level": "info",
        "Timestamp": true
      },
      "NTP": {
        "Enable": true,
        "Server": "time.apple.com",
        "ServerPort": 0
      },
      "OriginalPath": "/root/V2bX/sing_origin.json"      
    }
  ],
  "Nodes": [
    {
      "Core": "sing",
      "ApiHost": "https://cf.xcvpn.us",
      "ApiKey": "123e4567-e89b-12d3-a456-426655440009",
      "NodeID": $NODE_ID,
      "NodeType": "trojan",
      "Timeout": 30,
      "ListenIP": "::",
      "SendIP": "0.0.0.0",
      "EnableProxyProtocol": false,
      "EnableDNS": true,
      "DomainStrategy": "ipv4_only",
      "LimitConfig": {
        "EnableRealtime": false,
        "SpeedLimit": 0,
        "IPLimit": 0,
        "ConnLimit": 0,
        "EnableDynamicSpeedLimit": false,
        "DynamicSpeedLimitConfig": {
          "Periodic": 60,
          "Traffic": 1000,
          "SpeedLimit": 100,
          "ExpireTime": 60
        }
      },
      "CertConfig": {
        "CertMode": "self",
        "RejectUnknownSni": false,
        "CertDomain": "ithome.com",
        "CertFile": "/root/V2bX/cert.pem",
        "KeyFile": "/root/V2bX/private.pem",
        "Email": "aaaa@gmail.com",
        "Provider": "cloudflare",
        "DNSEnv": {
          "CF_DNS_API_TOKEN": "QcAznYiiBDc2wAmgVF5eRSG9MtoJW_9CENkRmx9umQ"
        }
      }
    }
  ]
}
EOF


# 创建XrayR 服务
echo "[Unit]
Description=V2bX Service
After=network.target

[Service]
Type=simple
ExecStart=/root/V2bX/V2bX server -c /root/V2bX/trojan.yml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/V2bX.service

# 重新加载 systemd 并启用服务
sudo systemctl daemon-reload
sudo systemctl enable V2bX.service
sudo systemctl start V2bX.service

echo "XrayR 服务已安装并启动。"

# 配置iptables规则
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F

# 重启并检查XrayR服务状态
sleep 2
sudo systemctl status V2bX
