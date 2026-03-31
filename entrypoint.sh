#!/bin/bash

# --- 1. 设置默认值 ---
VLESS_WSPATH=${VLESS_WSPATH:-"/imrzyangpathl"}
UUID=${UUID:-"d342d11e-d424-4583-b36e-524ab1f0afa4"}

echo "Configuring VLESS with Path: $VLESS_WSPATH and UUID: $UUID"

# --- 2. 动态修改配置文件 ---
# 使用 sed 替换 Nginx 和 Xray 配置中的占位符
sed -i "s|VLESS_WSPATH_PLACEHOLDER|$VLESS_WSPATH|g" /etc/nginx/nginx.conf
sed -i "s|VLESS_WSPATH_PLACEHOLDER|$VLESS_WSPATH|g" /etc/xray/config.json
sed -i "s|UUID_PLACEHOLDER|$UUID|g" /etc/xray/config.json

# --- 3. 启动进程 ---
nginx -g 'daemon off;' &
NGINX_PID=$!

/usr/local/bin/xray -config /etc/xray/config.json &
XRAY_PID=$!

# --- 4. 保活功能 (Keep-Alive) ---
if [ -n "$KEEPALIVE_URL" ] && [ -n "$KEEPALIVE_INTERVAL" ]; then
    echo "Keep-alive enabled. Target: $KEEPALIVE_URL every $KEEPALIVE_INTERVAL seconds."
    (
        while true; do
            sleep "$KEEPALIVE_INTERVAL"
            curl -s "$KEEPALIVE_URL" > /dev/null
            echo "Keep-alive ping sent to $KEEPALIVE_URL at $(date)"
        done
    ) &
fi

# --- 5. 进程守护循环 ---
while sleep 10; do
  kill -0 $NGINX_PID 2>/dev/null || exit 1
  kill -0 $XRAY_PID 2>/dev/null || exit 1
done
