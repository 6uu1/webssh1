#!/usr/bin/env bash
set -e

echo ">> Downloading wireproxy binary ..."

# 1. 找出最新版本号
TAG=$(curl -s https://api.github.com/repos/octeep/wireproxy/releases/latest \
      | grep '"tag_name":' | cut -d '"' -f 4)

# 2. 对应的压缩包文件名
TAR_FILE="wireproxy_linux_amd64.tar.gz"

# 3. 下载并解压到当前目录
curl -L "https://github.com/octeep/wireproxy/releases/download/${TAG}/${TAR_FILE}" \
  -o "${TAR_FILE}"

tar -xzf "${TAR_FILE}" wireproxy
chmod +x wireproxy
rm "${TAR_FILE}"

echo ">> wireproxy downloaded: $(./wireproxy -v)"