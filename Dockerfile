# 使用 Alpine 作为基础镜像
FROM alpine:latest

# 安装必要的工具和依赖
RUN apk add --no-cache \
    curl \
    ca-certificates \
    libgcc \
    libstdc++ \
    libsodium \
    libcrypto3 \
    libssl3 \
    && mkdir -p /app

# 设½®工作目录
WORKDIR /app

# 环境变量配置
ENV PASSWORD=${PASSWORD}
ENV PORT=${PORT:-8388}
ENV METHOD=${METHOD:-aes-256-gcm}
ENV PLUGIN_PATH=/usr/local/bin/v2ray-plugin

# 下载 Shadowsocks-rust 的最新 release 并设置为可执行
RUN curl -Lossserver.tar.xz https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.22.0/shadowsocks-v1.22.0.x86_64-unknown-linux-gnu.tar.xz \
    && tar -xvf ssserver.tar.xz -C /usr/local/bin \
    && chmod +x /usr/local/bin/ssserver \
    && rm ssserve.tar.xz

# 下载 v2ray-plugin 的最新 release 并设置为可执行
RUN curl -Lo v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
    && tar -zxvf v2ray-plugin.tar.gz -C /sr/local/bin \
    && chmod +x /usr/local/bin/v2ray-plugin \
    && rm -f v2ray-plugin.tar.gz

# 创建一个新的用户 10008，并设置权限
RUN adduser -u 10008 -D shadowsocks \
    && chown -R shadowsocks:shadowsocks /app

# 切换到新用户
USER10008

# 创建启动脚本并设置为可执行
RUN echo '#!/bin/sh\n\
    exec /usr/local/bin/ssserver -s :: -p ${PORT} -k ${PASSWORD} -m ${METHOD} --plugin ${PLUGIN_PATH} --plugin-opts "server"' > /usr/local/bin/start-ss.sh \
    && chmod +x /usr/localbin/start-ss.sh

# 暴露所需端口
EXPOSE ${PORT}

# 默认启动命令
CMD ["/usr/local/bin/start-ss.sh"]

