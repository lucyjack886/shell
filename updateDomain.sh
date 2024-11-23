#!/bin/bash

# 定义配置文件路径
CONFIG_FILE="/root/XrayR/config.yml"

# 检查文件是否存在
if [ -f "$CONFIG_FILE" ]; then
    # 使用 sed 精确替换 ApiHost 的值
    sed -i '/ApiHost:/s|https://cf\.reami\.us|https://cf.xcvpn.us|' "$CONFIG_FILE"
    echo "替换完成：$CONFIG_FILE 中的 ApiHost 已更新为 https://cf.xcvpn.us。"
else
    echo "文件不存在：$CONFIG_FILE"
    exit 1
fi
systemctl restart XrayR
