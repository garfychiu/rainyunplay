#!/bin/bash

# 容器启动配置脚本
echo "开始配置容器..."

# 1. 备份并配置镜像源
echo "配置阿里云镜像源..."
cp /etc/apt/sources.list /etc/apt/sources.list.backup 2>/dev/null || true

cat > /etc/apt/sources.list << 'EOF'
deb https://mirrors.aliyun.com/debian/ bullseye main non-free contrib
#deb-src https://mirrors.aliyun.com/debian/ bullseye main non-free contrib

deb https://mirrors.aliyun.com/debian-security/ bullseye-security main
#deb-src https://mirrors.aliyun.com/debian-security/ bullseye-security main

deb https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
#deb-src https://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib

deb https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
#deb-src https://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
EOF

echo "✅ 镜像源配置完成"

# 2. 更新软件包列表
echo "更新软件包列表..."
export DEBIAN_FRONTEND=noninteractive
apt-get update

# 3. 安装 SSH 服务器
echo "安装 OpenSSH 服务器..."
apt-get install -y openssh-server

# 4. 配置 SSH 允许 root 登录
echo "配置 SSH 允许 root 登录..."
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 5. 设置 root 密码
echo 'root: abcd@1234' | chpasswd

# 6. 创建 SSH 运行目录并启动服务
echo "启动 SSH 服务..."
mkdir -p /var/run/sshd
/usr/sbin/sshd

# 7. 验证 SSH 服务
if pgrep sshd > /dev/null; then
    echo "✅ SSH 服务启动成功"
    echo "📡 root 默认密码: abcd@1234 (请自行修改密码以确保安全)"
    echo "🔒 修改密码命令:"
    echo "   passwd root"
else
    echo "❌ SSH 服务启动失败"
fi

rm -f "/workspace/A【必看】面板常见问题解决.txt" /workspace/server.properties
echo 'cd /workspace' >> ~/.bashrc

echo "配置完成！"

echo ""
echo "========================================="
echo "⚠️  重要提醒："
echo "   每次容器重启后，只有 /workspace 目录下的文件会保留"
echo ""
echo "💡 建议："
echo "   1. 将重要文件放在 /workspace 目录下"
echo "========================================="

bash
