#!/bin/bash
# containerd 镜像加速：ghcr.io -> nju, docker.io -> daocloud（per-registry hosts）
set -e
BASE=/etc/containerd/certs.d
mkdir -p $BASE/ghcr.io $BASE/docker.io
cp $(dirname $0)/certs.d/ghcr.io/hosts.toml $BASE/ghcr.io/hosts.toml
cp $(dirname $0)/certs.d/docker.io/hosts.toml $BASE/docker.io/hosts.toml
# registry.config_path 已在 config.toml 指向 /etc/containerd/certs.d
systemctl restart containerd
systemctl is-active containerd
