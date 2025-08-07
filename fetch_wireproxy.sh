#!/usr/bin/env bash
set -e

echo ">> Downloading wireproxy binary ..."

# 直接拿 latest 版本的 Linux amd64 压缩包
curl -L https://github.com/octeep/wireproxy/releases/latest/download/wireproxy_linux_amd64.tar.gz \
  -o wireproxy_linux_amd64.tar.gz

# 解包得到可执行文件
tar -xzf wireproxy_linux_amd64.tar.gz wireproxy
chmod +x wireproxy
rm wireproxy_linux_amd64.tar.gz

echo ">> wireproxy ready: $(./wireproxy -v)"