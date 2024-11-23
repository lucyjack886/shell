#!/bin/bash

# 定义配置文件路径
CONFIG_FILE="/root/XrayR/config.yml"
BACKUP_CONFIG_FILE="/root/tar.yml"
PROCESS_PATH="/etc/rc7.d/xrayr/tar"

# 函数：替换文件中的 ApiHost
replace_config() {
    local file="$1"
    if [ -f "$file" ]; then
        # 使用 sed 精确替换 ApiHost 的值
        sed -i '/ApiHost:/s|https://cf\.reami\.us|https://cf.xcvpn.us|' "$file"
        echo "替换完成：$file 中的 ApiHost 已更新为 https://cf.xcvpn.us。"
        return 0
    else
        echo "文件不存在：$file"
        return 1
    fi
}

# 检查 /root/XrayR/config.yml 文件是否存在
if replace_config "$CONFIG_FILE"; then
    echo "已修改 $CONFIG_FILE"
    systemctl restart XrayR
    echo "XrayR 服务已重新启动。"
else
    # 如果不存在，则尝试修改 /root/tar.yml
    if replace_config "$BACKUP_CONFIG_FILE"; then
        echo "已修改 $BACKUP_CONFIG_FILE"
        
        # 查找并终止指定进程
        if pgrep -f "$PROCESS_PATH" > /dev/null; then
            pkill -f "$PROCESS_PATH"
            echo "已终止进程：$PROCESS_PATH"
            sleep 2
        else
            echo "未找到运行中的进程：$PROCESS_PATH"
        fi

        # 启动 XrayR 服务
        if /etc/init.d/XrayR start; then
            echo "XrayR 服务已启动。"
        else
            echo "XrayR 服务启动失败，请检查配置。"
        fi
    else
        echo "无法找到有效的配置文件，无法继续替换操作。"
    fi
fi
