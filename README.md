# 启动
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
## 💡 如何使用（以 Docker 为例）
你可以通过以下命令直接运行这个镜像：

Bash
docker run -d \
  -e UUID="你的自定义ID" \
  -e VLESS_WSPATH="/custom-path" \
  -e KEEPALIVE_URL="https://your-app.com" \
  -e KEEPALIVE_INTERVAL="300" \
  -p 8080:8080 \
  --name my-vless your-image-name

