#!/bin/bash
set -e
cp /root/k8s-deploy/01-containerd/containerd.service /etc/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd
echo "==== 状态 ===="
systemctl status containerd --no-pager
echo "==== 版本 ===="
containerd --version
ctr version
