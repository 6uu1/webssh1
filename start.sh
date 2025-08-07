#!/usr/bin/env bash
set -e

# 0) 用 envsubst 把模板里的 ${WARP_PRIVKEY} 注入实际值
envsubst < wgcf-profile.conf.template > wgcf-profile.conf

# 1) 启动 wireproxy（后台）
./wireproxy -c wireproxy.json &

# 2) 全局代理 → 走 WARP IPv6 出口
export ALL_PROXY="socks5h://127.0.0.1:1080"
export HTTP_PROXY=$ALL_PROXY
export HTTPS_PROXY=$ALL_PROXY

# 3) 启动 WebSSH
exec python run.py --port $PORT --address 0.0.0.0 --xheaders=False