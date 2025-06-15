#!/bin/bash

# 一键配置香港 XrayR 节点，识别 ChatGPT 流量转发到台湾节点

UUID="3893f375-5871-44d6-acee-66c0e39f6fc1"
TW_IPV6="217.142.187.79"
TW_PORT=18181

XRAYR_DIR="/root/XrayR"
ROUTING_DIR="${XRAYR_DIR}"

# 写入 custom_outbound.json
cat > "${ROUTING_DIR}/custom_outbound.json" <<EOF
[
  {
    "tag": "toTW",
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "$TW_IPV6",
          "port": $TW_PORT,
          "users": [
            {
              "user": "lucy@usa.com",
              "pass": "$UUID"
            }
          ]
        }
      ]
    },
    "streamSettings": {
      "network": "tcp"
    }
  },
  {
    "tag": "IPv4_out",
    "protocol": "freedom",
    "settings": {}
  },
  {
    "tag": "IPv6_out",
    "protocol": "freedom",
    "settings": {
      "domainStrategy": "UseIPv6"
    }
  },
  {
    "tag": "socks5-warp",
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "127.0.0.1",
          "port": 1080
        }
      ]
    }
  },
  {
    "protocol": "blackhole",
    "tag": "block",
    "settings": {}
  }
]
EOF

# 写入 route.json
cat > "${ROUTING_DIR}/route.json" <<EOF
{
  "domainStrategy": "IPOnDemand",
  "rules": [
    {
      "type": "field",
      "domain": [
        "*.openai.com",
        "openai.com",
        "chatgpt.com",
        "*.chatgpt.com"
      ],
      "outboundTag": "toTW"
    },
    {
      "type": "field",
      "outboundTag": "block",
      "ip": [
        "geoip:private"
      ]
    },
    {
      "type": "field",
      "outboundTag": "block",
      "protocol": [
        "bittorrent"
      ]
    },
    {
      "type": "field",
      "outboundTag": "IPv6_out",
      "domain": [
        "geosite:netflix"
      ]
    },
    {
      "type": "field",
      "outboundTag": "IPv4_out",
      "network": "udp,tcp"
    }
  ]
}
EOF



# 修改 config.yml 和 config_2.yml（如果存在）
for CONFIG_FILE in "/root/XrayR/config.yml" "/root/XrayR/config_2.yml"; do
  if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="${CONFIG_FILE}.bak.$(date +%s)"
    echo "📦 正在备份 $CONFIG_FILE 到 $BACKUP_FILE..."
    cp "$CONFIG_FILE" "$BACKUP_FILE"

    echo "🔧 修改 $CONFIG_FILE 的 RouteConfigPath 和 OutboundConfigPath..."
    sed -i 's|^#\?\s*RouteConfigPath:.*|RouteConfigPath: /root/XrayR/route.json|' "$CONFIG_FILE"
    sed -i 's|^#\?\s*OutboundConfigPath:.*|OutboundConfigPath: /root/XrayR/custom_outbound.json|' "$CONFIG_FILE"
  fi
done

systemctl restart XrayR && echo "✅ XrayR 已重启成功。" || echo "❌ XrayR 重启失败，请检查日志。"
if [ -f "/root/XrayR/config_2.yml" ]; then
  echo "🔁 检测到 config_2.yml，重启 XrayR_2..."
  systemctl restart XrayR_2 && echo "✅ XrayR_2 已重启成功。" || echo "❌ XrayR_2 重启失败，请检查日志。"
fi
