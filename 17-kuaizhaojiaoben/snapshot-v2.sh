#!/bin/bash
set -e

VERSION="v2"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
# 备份目录改为外部的 banbe 文件夹
BACKUP_DIR="/root/banbe"
SNAPSHOT_NAME="${VERSION}-${TIMESTAMP}"
SNAPSHOT_PATH="${BACKUP_DIR}/${SNAPSHOT_NAME}"

echo "================ 开始封装 Version ${VERSION} ================"
echo "快照名称: ${SNAPSHOT_NAME}"

mkdir -p "${SNAPSHOT_PATH}"

echo "1. 导出集群核心资源对象..."
kubectl get ns -o yaml > "${SNAPSHOT_PATH}/ns.yaml"
kubectl get pvc -A -o yaml > "${SNAPSHOT_PATH}/pvc.yaml"
kubectl get svc -A -o yaml > "${SNAPSHOT_PATH}/svc.yaml"
kubectl get deployment,statefulset,daemonset -A -o yaml > "${SNAPSHOT_PATH}/workloads.yaml"
kubectl get backupstoragelocation -n velero -o yaml > "${SNAPSHOT_PATH}/velero-bsl.yaml" 2>/dev/null || true

echo "2. 打包所有代码资产..."
tar -czvf "${SNAPSHOT_PATH}/k8s-deploy-source.tar.gz" /root/k8s-deploy/

echo "3. 创建版本软链接..."
ln -sfn "${SNAPSHOT_PATH}" "${BACKUP_DIR}/latest"
ln -sfn "${SNAPSHOT_PATH}/k8s-deploy-source.tar.gz" "${BACKUP_DIR}/latest.tar.gz"

echo "✅ Version ${VERSION} 封装完成！"
echo "快照目录: ${SNAPSHOT_PATH}"
echo "最新软链接: ${BACKUP_DIR}/latest"
