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
