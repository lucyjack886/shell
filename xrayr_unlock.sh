cd /root/XrayR
# 创建配置文件 route.json
cat <<EOF > route.json
{
  "domainStrategy": "IPOnDemand",
  "rules": [
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
      "outboundTag": "socks5-warp",
      "domain": ["chatgpt.com","openai.com"]
    },
    {
      "type": "field",
      "outboundTag": "socks5-warp-ipv6",
      "domain": [
        "geosite:netflix","geosite:disney","geosite:hbo"
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

# 创建配置文件 custom_outbound.json
cat <<EOF > custom_outbound.json
[
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
          "port": 40000 
        }
      ]
    }
  },
  {
    "tag": "socks5-warp-ipv6",
    "protocol": "socks",
    "settings": {
      "servers": [
        {
          "address": "::1",
          "port": 40000
        }
      ]
    }
  },
  {
    "protocol": "blackhole",
    "tag": "block"
  }
]
EOF


# Path to the config file
CONFIG_FILE="/root/XrayR/config.yml"

# Check if the config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config file not found!"
  exit 1
fi

# Replace the required lines
sed -i 's|RouteConfigPath: # /etc/XrayR/route.json|RouteConfigPath: /root/XrayR/route.json|' "$CONFIG_FILE"
sed -i 's|OutboundConfigPath: # /etc/XrayR/custom_outbound.json|OutboundConfigPath: /root/XrayR/custom_outbound.json|' "$CONFIG_FILE"
echo "Config file updated successfully!"
systemctl restart XrayR

# 配置文件的路径
CONFIG_FILE="/etc/wireguard/proxy.conf"
# 检查配置文件是否存在
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "配置文件未找到！"
  exit 1
fi

# 使用 sed 命令进行替换
sed -i 's|BindAddress = 127.0.0.1:40000|BindAddress = :40000|' "$CONFIG_FILE"

echo "配置文件更新成功！"

systemctl restart wireproxy

