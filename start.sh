#!/bin/sh

# 从环境变量读取配置，设置默认值（如果环境变量没有提供）
SERVER_ADDR="${SERVER_ADDR:-::}"           # 默认 IPv6 地址
SERVER_PORT="${SERVER_PORT:-3000}"         # 默认端口 3000
PASSWORD="${PASSWORD:-1234}"               # 默认密码 1234
TOKEN="${TOKEN:-1234}"

# 输出配置信息（可选，方便调试）
echo "Starting Shadowsocks server with the following configuration:"
echo "Server Address: $SERVER_ADDR"
echo "Server Port: $SERVER_PORT"
echo "Encryption Method: $ENCRYPTION_METHOD"

/usr/local/bin/cloudflared tunnel --edge-ip-version auto --no-autoupdate --protocol http2 run --token "${TOKEN}" & >/dev/null 2>&1

/usr/local/bin/ttyd -i :: --port 7681 --credential test:123 --writable --ipv6 bash

