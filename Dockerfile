# 使用Debian作为基础镜像
FROM debian:latest

# 设置环境变量
ENV PASSWORD=""
ENV PORT=3000

# 更新包管理器并安装必要的软件
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    adduser \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 下载并安装ttyd
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 -O /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

# 下载并安装cfd
RUN wget https://github.com/cloudflare/cloudflared/releases/download/2025.1.0/cloudflared-linux-amd64 -O /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 创建用户 10014，并设置为默认运行用户
RUN adduser --uid 10014 --disabled-password --gecos "" ss && \
    mkdir -p /app && chown -R ss:ss /app

# 创建启动脚本并设置为可执行
COPY start.sh /usr/local/bin/start.sh
# 切换到用户 10014
USER 10014


# 暴露所需端口
EXPOSE ${PORT}

CMD ["sh", "/usr/local/bin/start.sh"]
