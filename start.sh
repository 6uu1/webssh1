#!/usr/bin/env bash
set -e

# 把 ${WARP_PRIVKEY} 注入模板生成正式配置
sed "s|\${WARP_PRIVKEY}|${WARP_PRIVKEY}|g" \
    wgcf-profile.conf.template > wgcf-profile.conf

# 如需覆盖默认的 WARP 接入点，设置环境变量 WARP_ENDPOINT，例如：
# WARP_ENDPOINT="162.159.193.10:2408" 或 "engage.cloudflareclient.com:2408"
if [ -n "${WARP_ENDPOINT:-}" ]; then
  sed -i "s|^Endpoint = .*|Endpoint = ${WARP_ENDPOINT}|" wgcf-profile.conf
  echo ">> Using custom WARP endpoint: ${WARP_ENDPOINT}"
fi

# 若 wireproxy 不存在，尝试下载
if [ ! -x ./wireproxy ]; then
  echo ">> wireproxy not found, fetching..."
  ./fetch_wireproxy.sh
fi

# 启动 wireproxy（使用 INI 配置）
echo ">> Starting wireproxy ..."
./wireproxy -c wireproxy.conf &

export ALL_PROXY="socks5h://127.0.0.1:1080"

# 探测通过 SOCKS5（WARP）走 IPv6 出口是否可用
if command -v curl >/dev/null 2>&1; then
  echo ">> Probing IPv6 via SOCKS5 (api64.ipify.org) ..."
  PROBE_OK=""
  for i in 1 2 3 4 5; do
    IPV6=$(curl -sS -6 --socks5-hostname 127.0.0.1:1080 https://api64.ipify.org -m 5 || true)
    if [ -n "$IPV6" ]; then
      echo ">> WARP IPv6 via SOCKS OK: ${IPV6}"
      PROBE_OK=1
      break
    else
      echo ">> Probe #${i} failed, retrying ..."
      sleep 2
    fi
  done
  if [ -z "$PROBE_OK" ]; then
    echo ">> SOCKS over WARP failed (cannot reach api64.ipify.org over IPv6)"
  fi
else
  echo ">> curl not found; skipping IPv6 probe"
fi

# 若 $PORT 为空，默认 8888
#exec python run.py --port=${PORT:-8888} --address=0.0.0.0 --xheaders=False
exec python run.py \
  --port=${PORT:-8888} \
  --address=0.0.0.0 \
  --xheaders=False \
  --proxy_type=socks5 \
  --proxy_host=127.0.0.1 \
  --proxy_port=1080