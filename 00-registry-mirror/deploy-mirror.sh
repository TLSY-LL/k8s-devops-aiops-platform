#!/bin/bash
# 把 registry.gitlab.com 缓存指向同步到集群各节点并重载 containerd
# 用法: bash deploy-mirror.sh   (在 master 执行, 需能 ssh 到各节点)
set -e
SRC=/root/k8s-deploy/00-registry-mirror/certs.d/registry.gitlab.com/hosts.toml
NODES="k8s-node1 k8s-node2"

for n in $NODES; do
  echo "===== $n ====="
  ssh root@$n 'mkdir -p /etc/containerd/certs.d/registry.gitlab.com'
  scp "$SRC" root@$n:/etc/containerd/certs.d/registry.gitlab.com/hosts.toml
  ssh root@$n 'grep -q "config_path = .*/etc/containerd/certs.d" /etc/containerd/config.toml \
    && echo "config_path OK" || echo "!! 缺 config_path, 需先配"
  systemctl restart containerd
  sleep 3
  systemctl is-active containerd
  curl -s -o /dev/null -w "node->.63:5000 HTTP %{http_code}\n" http://192.168.148.63:5000/v2/'
done
