#!/usr/bin/env bash
set -e

# 把 ${WARP_PRIVKEY} 注入模板生成正式配置
sed "s|\${WARP_PRIVKEY}|${WARP_PRIVKEY}|g" \
    wgcf-profile.conf.template > wgcf-profile.conf

# 启动 wireproxy
./wireproxy -c wireproxy.conf &

export ALL_PROXY="socks5h://127.0.0.1:1080"
# 若 $PORT 为空，默认 8888
PORT=${PORT:-8888}
exec python run.py --port "$PORT" --address 0.0.0.0 --xheaders=False