#!/bin/bash
set -e
kubeadm init --config /root/k8s-deploy/03-kubeadm-init/kubeadm-config.yaml
# 配置 root 的 kubeconfig
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
echo "==== 初始化完成，节点状态 ===="
kubectl get nodes -o wide
