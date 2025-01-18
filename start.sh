#!/bin/sh

# 从环境变量读取配置，设置默认值（如果环境变量没有提供）
SERVER_ADDR="${SERVER_ADDR:-::}"           # 默认 IPv6 地址
SERVER_PORT="${SERVER_PORT:-3000}"         # 默认端口 3000
PASSWORD="${PASSWORD:-1234}"               # 默认密码 1234
ENCRYPTION_METHOD="${ENCRYPTION_METHOD:-aes-256-gcm}"  # 默认加密方法

# 输出配置信息（可选，方便调试）
echo "Starting Shadowsocks server with the following configuration:"
echo "Server Address: $SERVER_ADDR"
echo "Server Port: $SERVER_PORT"
echo "Encryption Method: $ENCRYPTION_METHOD"

# 执行 ssserver 命令启动 Shadowsocks 服务
/usr/local/bin/ssserver -s "$SERVER_ADDR:$SERVER_PORT" -k "$PASSWORD" -m "$ENCRYPTION_METHOD" --plugin /usr/local/bin/v2ray-plugin_linux_amd64 --plugin-opts "server"
