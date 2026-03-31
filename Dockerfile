FROM alpine:latest

# 安装依赖
RUN apk add --no-cache nginx bash curl unzip

# 下载 Xray
RUN curl -L https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o xray.zip && \
    unzip xray.zip && mv xray /usr/local/bin/ && rm -rf xray.zip

# 准备目录
RUN mkdir -p /etc/xray /var/www/html /run/nginx
RUN echo '<h1>System Active</h1>' > /var/www/html/index.html

# 复制文件
COPY config.json /etc/xray/config.json
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露端口
EXPOSE 8080

# 启动
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
