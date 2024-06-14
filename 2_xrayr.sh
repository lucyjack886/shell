#!/bin/bash

# 获取有效的 NodeID 输入
while true; do
  read -p "请输入NodeID (必须为数字): " NODE_ID
  if [[ "$NODE_ID" =~ ^[0-9]+$ ]]; then
    break
  else
    echo "无效输入，请输入一个有效的数字。"
  fi
done

echo "你输入的NodeID是: $NODE_ID"

# 创建配置文件 config_2.yml
cat <<EOF > /root/XrayR/config_2.yml
Log:
  Level: warning # Log level: none, error, warning, info, debug
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config, check https://xtls.github.io/config/dns.html for help
RouteConfigPath: # /etc/XrayR/route.json # Path to route config, check https://xtls.github.io/config/routing.html for help
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config, check https://xtls.github.io/config/inbound.html for help
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config, check https://xtls.github.io/config/outbound.html for help
ConnectionConfig:
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 30 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB
Nodes:
  -
    PanelType: "NewV2board" # Panel type: SSpanel, V2board, NewV2board, PMpanel, Proxypanel, V2RaySocks
    ApiConfig:
      ApiHost: "https://goudan.site"
      ApiKey: "123e4567-e89b-12d3-a456-426655440009"
      NodeID: $NODE_ID
      NodeType: Shadowsocks  # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: 0 # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: 0 # Local settings will replace remote settings, 0 means disable
      RuleListPath: # /etc/XrayR/rulelist Path to local rulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send package
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      AutoSpeedLimitConfig:
        Limit: 0 # Warned speed. Set to 0 to disable AutoSpeedLimit (mbps)
        WarnTimes: 0 # After (WarnTimes) consecutive warnings, the user will be limited. Set to 0 to punish overspeed user immediately.
        LimitSpeed: 0 # The speedlimit of a limited user (unit: mbps)
        LimitDuration: 0 # How many minutes will the limiting last (unit: minute)
      GlobalDeviceLimitConfig:
        Enable: false # Enable the global device limit of a user
        RedisAddr: 127.0.0.1:6379 # The redis server address
        RedisPassword: "YOUR_PASSWORD" # Redis password
        RedisDB: 0 # Redis DB
        Timeout: 5 # Timeout for redis request
        Expiry: 60 # Expiry time (second)
      EnableFallback: false # Only support for Trojan and Vless
EOF

# 创建XrayR 服务
cat <<EOF | sudo tee /etc/systemd/system/XrayR_2.service
[Unit]
Description=XrayR_2 Service
After=network.target

[Service]
Type=simple
ExecStart=/root/XrayR/XrayR --config /root/XrayR/config_2.yml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 并启用服务
sudo systemctl daemon-reload
sudo systemctl enable XrayR_2.service
sudo systemctl start XrayR_2.service

echo "XrayR_2 服务已安装并启动。"

# 配置iptables规则
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F

# 等待服务启动
sleep 2

# 检查XrayR服务状态
sudo systemctl status XrayR_2
