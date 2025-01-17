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
ENV SS_PASSWORD=${SS_PASSWORD}
ENV SS_PORT=${SS_PORT:-8388}
ENV SS_METHOD=${SS_METHOD:-aes-256-gcm}
ENV PLUGIN_PATH=/usr/local/bin/v2ray-plugin
ENV PLUGIN_PASSWORD=${PLUGIN_PASSWORD}

# 下载 Shadowsocks-ust 的最新 release 并设置为可执行
RUN curl -Lo ssserver.tar.xz https://github.com/shadowsocks/shadowsocks-rust/releases/latest/download/shadowsocks-v2.0.0-beta.9-x86_64-unknown-linux-musl.tar.xz \
    && tar -xvf ssserver.tar.xz -C /usr/local/bi \
    && chmod +x /usr/local/bin/ssserver \
    && rm ssserver.tar.xz

# 下载 v2ray-plugin 的最新 release 并设置为可执行
RUN curl -Lo v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/latest/download/v2ray-plugin-linux-md64-v4.44.0.tar.gz \
    && tar -zxvf v2ray-plugin.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/v2ray-plugin \
    && rm -f v2ray-plugin.tar.gz

# 创建一个新的用户 10008，并设置权限
RUN adduser -u 10008 -D shadowsocks \
    && hown -R shadowsocks:shadowsocks /app

# 切换到新用户
USER 10008

# 创建启动脚本并设置为可执行
RUN echo '#!/bin/sh\n\
    exec /usr/local/bin/ssserver -s 0.0.0.0 -p ${SS_PORT} -k ${SS_PASSWORD} -m ${SS_METHOD} --plugin ${PLUGIN_PATH} --pugin-opts "server;${PLUGIN_PASSWORD}"' > /usr/local/bin/start-ss.sh \
    && chmod +x /usr/local/bin/start-ss.sh

# 暴露所需端口
EXPOSE ${SS_PORT}

# 默认启动命令
CMD ["/usr/local/bin/start-ss.sh"]

