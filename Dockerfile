# 使用 Alpine 作为基础镜像
FROM debian:latest

# 安装必要的工具和依赖
RUN apt update && apt install \
    curl \
    ca-certificates \
    libgcc \
    libstdc++ \
    libsodium \
    libcrypto3 \
    libssl3 \
    && mkdir -p /app

# 设置工作目录
WORKDIR /app

# 环境变量配置
ENV PASSWORD=${PASSWORD}
ENV PORT=${PORT:-8388}
ENV METHOD=${METHOD:-aes-256-gcm}
ENV PLUGIN_PATH=/usr/local/bin/v2ray-plugin_linux_amd64

# 下载 Shadowsocks-rust 的最新 release 并设置为可执行
RUN curl -Lo ssserver.tar.xz https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.22.0/shadowsocks-v1.22.0.x86_64-unknown-linux-gnu.tar.xz \
    && tar -xvf ssserver.tar.xz -C /usr/local/bin \
    && chmod +x /usr/local/bin/ssserver \
    && rm -f ssserver.tar.xz

# 下载 v2ray-plugin 的最新 release 并设置为可执行
RUN curl -Lo v2ray-plugin.tar.gz https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.2/v2ray-plugin-linux-amd64-v1.3.2.tar.gz \
    && tar -zxvf v2ray-plugin.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/v2ray-plugin_linux_amd64 \
    && rm -f v2ray-plugin.tar.gz

# 创建用户 10014，并设置为默认运行用户
RUN adduser -u 10014 -D ss \
    && chown -R ss:ss /app

# 创建启动脚本并设置为可执行
COPY start.sh /usr/local/bin/start.sh
# 切换到用户 10014
USER 10014


# 暴露所需端口
EXPOSE ${PORT}

CMD ["sh", "/usr/local/bin/start.sh"]
