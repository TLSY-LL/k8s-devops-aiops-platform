#!/bin/bash
PASS=0; FAIL=0
ok()  { echo -e "\033[32m[PASS]\033[0m $1"; PASS=$((PASS+1)); }
bad() { echo -e "\033[31m[FAIL]\033[0m $1"; FAIL=$((FAIL+1)); }

echo "========== 1. 节点状态 =========="
NOTREADY=$(kubectl get nodes --no-headers 2>/dev/null | grep -v " Ready " | wc -l)
[ "$NOTREADY" -eq 0 ] && ok "所有节点 Ready" || bad "有 $NOTREADY 个节点非 Ready"
kubectl get nodes

echo "========== 2. 集群内 CoreDNS 真实解析 =========="
kubectl delete pod net-probe --ignore-not-found >/dev/null 2>&1
kubectl run net-probe --image=docker.m.daocloud.io/library/busybox:latest \
  --restart=Never --overrides='{"spec":{"nodeSelector":{"kubernetes.io/hostname":"k8s-node1"}}}' -- sleep 300 >/dev/null 2>&1
kubectl wait pod/net-probe --for=condition=Ready --timeout=60s >/dev/null 2>&1
kubectl exec net-probe -- nslookup kubernetes.default 2>/dev/null | grep -q "Address" && ok "CoreDNS 基础解析成功" || bad "CoreDNS 解析失败"

echo "========== 3. 存储健康度 =========="
kubectl get sc nfs-client >/dev/null 2>&1 && ok "StorageClass nfs-client 存在" || bad "缺 StorageClass nfs-client"
kubectl get pods -n default -l app=nfs-client-provisioner | grep -q "Running" && ok "NFS Provisioner 运行正常" || bad "NFS Provisioner 异常"

echo "========== 4. 核心链路连通性 =========="
# 测试 GitLab 和监控的核心 Service
kubectl exec net-probe -- nc -z -w 3 gitlab-app.gitlab.svc.cluster.local 80 2>/dev/null && ok "GitLab 服务连通" || bad "GitLab 服务不通"
kubectl exec net-probe -- nc -z -w 3 kube-prom-kube-prometheus-prometheus.monitoring.svc.cluster.local 9090 2>/dev/null && ok "Prometheus 服务连通" || bad "Prometheus 服务不通"

kubectl delete pod net-probe --ignore-not-found >/dev/null 2>&1

echo "========== 结果: PASS=$PASS FAIL=$FAIL =========="
[ "$FAIL" -eq 0 ] && echo -e "\033[32m>>> 集群基础健康度极佳\033[0m" || echo -e "\033[31m>>> 存在失败项，请逐个排查\033[0m"
