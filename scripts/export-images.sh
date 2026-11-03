#!/bin/bash
set -e

echo "🔍 正在从所有的 YAML 文件中提取镜像名称..."
grep -rh "image:" /root/TLSY-Cloud/ | awk '{print $2}' | tr -d '"' | sort -u > /tmp/image-list.txt
cat /tmp/image-list.txt

echo "🚀 开始通过 ctr 导出镜像..."
mkdir -p /root/offline-images
cd /root/offline-images

while IFS= read -r img; do
    if [ -z "$img" ]; then continue; fi
    filename=$(echo "$img" | tr '/:' '_')
    echo "正在导出: $img -> $filename.tar"
    ctr -n k8s.io images export "$filename.tar" "$img" || echo "⚠️ 导出 $img 失败"
done < /tmp/image-list.txt

echo "🗜️ 正在压缩镜像包..."
tar -czvf /root/TLSY-Cloud-images.tar.gz *.tar

echo "✅ 导出完成！离线镜像包路径: /root/TLSY-Cloud-images.tar.gz"
