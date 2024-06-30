
#!/bin/bash

        sudo iptables -P INPUT ACCEPT
        sudo iptables -P FORWARD ACCEPT
        sudo iptables -P OUTPUT ACCEPT
        sudo iptables -F

# 删除 admin 组（如果存在）
sudo groupdel admin

# 创建 admin 用户
sudo useradd -m admin

# 获取操作系统的名字
OS_NAME=$(grep ^ID= /etc/os-release | cut -d'=' -f2)

# 去掉引号（如果存在）
OS_NAME=${OS_NAME//\"/}

# 根据操作系统名字执行相应的命令
if [ "$OS_NAME" == "centos" ]; then
    echo "Detected CentOS. Adding user 'admin' to the wheel group."
    sudo usermod -aG wheel admin
else
    echo "Detected non-CentOS system. Adding user 'admin' to the sudo group."
    sudo usermod -aG sudo admin
fi

# 配置 sudoers 文件，使 admin 用户执行 sudo 不需要密码
echo "admin ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/admin

# 配置 SSH 允许密码认证和 root 登录
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo rm -rf /etc/ssh/sshd_config.d/*.conf
sudo systemctl restart sshd

# 设置 admin 用户的密码
echo 'admin:12345@QWE123' | sudo chpasswd

