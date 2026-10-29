#!/bin/bash
echo "================ K8s 集群快速体检 ================"
echo "--- 1. 节点状态 ---"
kubectl get nodes -o wide
echo -e "\n--- 2. 异常 Pod 检测 (排除系统组件) ---"
kubectl get pods -A | grep -vE "Running|Completed" | grep -vE "kube-system|calico|metallb|nginx-gateway|tigera"
echo -e "\n--- 3. 核心业务与监控状态 ---"
kubectl get pods -n gitlab-app
kubectl get pods -n monitoring
echo -e "\n--- 4. 存储 PVC 状态 ---"
kubectl get pvc -n gitlab-app
kubectl get pvc -n monitoring
echo -e "\n--- 5. 节点资源消耗 ---"
kubectl top nodes
echo "================ 体检结束 ================"
