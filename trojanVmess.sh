#!/bin/bash

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
mkdir -p XrayR
cd XrayR

# 获取系统架构
ARCH=$(uname -m)

# 根据系统架构下载并解压相应的文件
if [ "$ARCH" == "x86_64" ]; then
    echo "Detected x86_64 architecture."
    wget https://github.com/XrayR-project/XrayR/releases/download/v0.9.1/XrayR-linux-64.zip
    unzip XrayR-linux-64.zip
elif [[ "$ARCH" == arm* || "$ARCH" == aarch* ]]; then
    echo "Detected ARM architecture."
    wget https://github.com/XrayR-project/XrayR/releases/download/v0.9.1/XrayR-linux-arm64-v8a.zip
    unzip XrayR-linux-arm64-v8a.zip
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi


CONFIG_FILE="/root/XrayR/config.yml"

# 提示用户选择 NodeType
while true; do
    echo "请选择 NodeType:"
    echo "1) V2ray"
    echo "2) Trojan"
    read -p "请输入选项 (1 或 2): " choice
    case $choice in
        1)
            NodeType="V2ray"
            break
            ;;
        2)
            NodeType="Trojan"
            break
            ;;
        *)
            echo "无效的选项，请重新选择。"
            ;;
    esac
done

# 提示用户输入 NodeID
while true; do
    read -p "请输入 NodeID (必须是数字): " NodeID
    if [[ $NodeID =~ ^[0-9]+$ ]]; then
        break
    else
        echo "输入的 NodeID 无效，请重新输入一个数字。"
    fi
done

if [[ $NodeType == "Trojan" ]]; then
    CONTENT=$(cat <<EOF
Log:
  Level: warning
  AccessPath: 
  ErrorPath: 
DnsConfigPath: 
RouteConfigPath: 
InboundConfigPath: 
OutboundConfigPath: 
ConnectionConfig:
  Handshake: 4
  ConnIdle: 30
  UplinkOnly: 2
  DownlinkOnly: 4
  BufferSize: 64
Nodes:
  - PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "https://cf.xcvpn.us"
      ApiKey: "123e4567-e89b-12d3-a456-426655440009"
      NodeID: $NodeID
      NodeType: $NodeType
      Timeout: 30
      EnableVless: false
      VlessFlow: "xtls-rprx-vision"
      SpeedLimit: 0
      DeviceLimit: 0
      RuleListPath: 
      DisableCustomConfig: false
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
      GlobalDeviceLimitConfig:
        Enable: false
        RedisAddr: 127.0.0.1:6379
        RedisPassword: YOUR_PASSWORD
        RedisDB: 0
        Timeout: 5
        Expiry: 60
      EnableFallback: false
      FallBackConfigs:
        - Dest: 80
          ProxyProtocolVer: 0
      DisableLocalREALITYConfig: false
      EnableREALITY: false
      REALITYConfigs:
        Show: true
        Dest: www.smzdm.com:443
        ProxyProtocolVer: 0
        ServerNames:
          - www.smzdm.com
        PrivateKey: YOUR_PRIVATE_KEY
        ShortIds:
          - ""
          - 0123456789abcdef
      CertConfig:
        CertMode: file
        CertDomain: "node1.test.com"
        CertFile: /root/cert/server.crt
        KeyFile: /root/cert/server.key
        Provider: alidns
        Email: test@me.com
        DNSEnv:
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOF
    )
else
    CONTENT=$(cat <<EOF

  -
    PanelType: "NewV2board"
    ApiConfig:
      ApiHost: "https://cf.xcvpn.us"
      ApiKey: "123e4567-e89b-12d3-a456-426655440009"
      NodeID: $NodeID
      NodeType: $NodeType
      Timeout: 30
      EnableVless: false
      EnableXTLS: false
      SpeedLimit: 0
      DeviceLimit: 0
      RuleListPath: 
    ControllerConfig:
      ListenIP: 0.0.0.0
      SendIP: 0.0.0.0
      UpdatePeriodic: 60
      EnableDNS: false
      DNSType: AsIs
      EnableProxyProtocol: false
      AutoSpeedLimitConfig:
        Limit: 0
        WarnTimes: 0
        LimitSpeed: 0
        LimitDuration: 0
EOF
    )
fi

# 写入配置文件
echo "$CONTENT" > "$CONFIG_FILE"

# 输出结果
echo "内容已成功写入 $CONFIG_FILE"
echo "NodeType: $NodeType"
echo "NodeID: $NodeID"
