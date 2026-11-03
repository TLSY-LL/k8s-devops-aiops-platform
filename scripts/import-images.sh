#!/bin/bash
set -e

if [ ! -f "$1" ]; then
    echo "❌ 用法: ./import-images.sh <离线包路径.tar.gz>"
    exit 1
fi

echo "📦 正在解压离线镜像包..."
mkdir -p /tmp/tlsy-images
tar -xzvf "$1" -C /tmp/tlsy-images

echo "🚀 开始导入镜像到 containerd..."
cd /tmp/tlsy-images
for tar_file in *.tar; do
    echo "正在导入: $tar_file"
    ctr -n k8s.io images import "$tar_file"
done

echo "🧹 清理临时文件..."
rm -rf /tmp/tlsy-images
echo "✅ 所有镜像导入完成！"
