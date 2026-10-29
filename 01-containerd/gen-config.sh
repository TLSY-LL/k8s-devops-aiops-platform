#!/bin/bash
set -e
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
# cgroup driver -> systemd（与 kubelet 一致）
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
# 2.4.2: CRI pause 沙箱镜像换国内源（新插件 io.containerd.cri.v1.images.pinned_images.sandbox）
sed -i "s#sandbox = 'registry.k8s.io/pause:3.10.2'#sandbox = 'registry.aliyuncs.com/google_containers/pause:3.10.2'#" /etc/containerd/config.toml
echo "==== config 校验 ===="
grep -E 'SystemdCgroup|sandbox' /etc/containerd/config.toml
