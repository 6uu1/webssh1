#!/usr/bin/env bash
set -e

echo ">> Downloading wireproxy binary ..."
curl -L https://github.com/octeep/wireproxy/releases/latest/download/wireproxy-linux-amd64 \
  -o wireproxy
chmod +x wireproxy