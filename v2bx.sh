#!/bin/bash

# 获取用户输入的 CertDomain 和 NodeID
read -p "Enter CertDomain: " certDomain
read -p "Enter NodeID: " nodeID

# 配置文件内容
configContent=$(cat <<EOL
{
    "Log": {
        "Level": "error",
        "Output": ""
    },
    "Cores": [
        {
            "Type": "sing",
            "Log": {
                "Level": "error",
                "Timestamp": true
            },
            "NTP": {
                "Enable": false,
                "Server": "time.apple.com",
                "ServerPort": 0
            },
            "OriginalPath": "/etc/V2bX/sing_origin.json"
        }
    ],
    "Nodes": [
        {
            "Core": "sing",
            "ApiHost": "https://cf.xcvpn.us",
            "ApiKey": "123e4567-e89b-12d3-a456-426655440009",
            "NodeID": ${nodeID},
            "NodeType": "hysteria2",
            "Timeout": 30,
            "ListenIP": "::",
            "SendIP": "0.0.0.0",
            "DeviceOnlineMinTraffic": 100,
            "TCPFastOpen": true,
            "SniffEnabled": true,
            "EnableDNS": true,
            "CertConfig": {
                "CertMode": "self",
                "RejectUnknownSni": false,
                "CertDomain": "${certDomain}",
                "CertFile": "/etc/V2bX/fullchain.cer",
                "KeyFile": "/etc/V2bX/cert.key",
                "Email": "v2bx@github.com",
                "Provider": "cloudflare",
                "DNSEnv": {
                    "EnvName": "env1"
                }
            }
        }
    ]
}
EOL
)

# 将配置写入文件
echo "${configContent}" > /etc/V2bX/config.json

echo "Configuration has been written to /etc/V2bX/config.json"
