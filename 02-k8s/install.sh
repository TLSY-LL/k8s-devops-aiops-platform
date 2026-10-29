#!/bin/bash
set -e
VER=1.36.5-1.1
apt update
apt install -y kubelet=${VER} kubeadm=${VER} kubectl=${VER}
# 锁版本，防止 apt upgrade 带走
apt-mark hold kubelet kubeadm kubectl
# 注册开机自启（不手动 start，kubeadm init 后由集群拉起）
systemctl enable kubelet
echo "==== 版本校验 ===="
kubelet --version
kubeadm version -o short
kubectl version --client -o yaml 2>/dev/null | grep gitVersion || kubectl version --client
