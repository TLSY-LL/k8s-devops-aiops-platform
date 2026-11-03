#!/bin/bash
PASS=0; FAIL=0
ok()  { echo -e "\033[32m[PASS]\033[0m $1"; PASS=$((PASS+1)); }
bad() { echo -e "\033[31m[FAIL]\033[0m $1"; FAIL=$((FAIL+1)); }

echo "================ K8s 日常巡检 ================"
echo "--- 1. 节点状态 ---"
kubectl get nodes -o wide
NOTREADY=$(kubectl get nodes --no-headers 2>/dev/null | grep -v " Ready " | wc -l)
[ "$NOTREADY" -eq 0 ] && ok "所有节点 Ready" || bad "有 $NOTREADY 个节点非 Ready"

echo -e "\n--- 2. 异常 Pod 检测 (排除系统组件) ---"
kubectl get pods -A | grep -vE "Running|Completed" | grep -vE "kube-system|calico|metallb|nginx-gateway|tigera" || echo "✅ 无异常 Pod"

echo -e "\n--- 3. 核心业务与监控状态 ---"
kubectl get pods -n gitlab-app
kubectl get pods -n monitoring
kubectl get pods -n harbor

echo -e "\n--- 4. 缩容组件状态 ---"
components=(
  "monitoring kube-prom-kube-state-metrics"
  "velero velero"
  "argocd argocd-applicationset-controller"
  "nginx-gateway ngf-nginx-gateway-fabric"
)
for comp in "${components[@]}"; do
  ns=$(echo $comp | awk '{print $1}')
  name=$(echo $comp | awk '{print $2}')
  echo -n "  $ns/$name: "
  kubectl get deploy $name -n $ns 2>/dev/null | grep -v NAME | awk '{print $2}' || echo "未找到"
done

echo -e "\n--- 5. 存储 PVC 状态 ---"
kubectl get pvc -A

echo -e "\n--- 6. 节点资源消耗 ---"
kubectl top nodes

echo -e "\n--- 7. 集群内 DNS 与核心链路检查 ---"
kubectl delete pod net-probe --ignore-not-found >/dev/null 2>&1
kubectl run net-probe --image=docker.m.daocloud.io/library/busybox:latest \
  --restart=Never --overrides='{"spec":{"nodeSelector":{"kubernetes.io/hostname":"k8s-node1"}}}' -- sleep 60 >/dev/null 2>&1
kubectl wait pod/net-probe --for=condition=Ready --timeout=30s >/dev/null 2>&1
kubectl exec net-probe -- nslookup kubernetes.default 2>/dev/null | grep -q "Address" && ok "CoreDNS 解析成功" || bad "CoreDNS 解析失败"
kubectl exec net-probe -- nc -z -w 3 gitlab-app.gitlab.svc.cluster.local 80 2>/dev/null && ok "GitLab 服务连通" || bad "GitLab 服务不通"
kubectl exec net-probe -- nc -z -w 3 kube-prom-kube-prometheus-prometheus.monitoring.svc.cluster.local 9090 2>/dev/null && ok "Prometheus 服务连通" || bad "Prometheus 服务不通"
kubectl delete pod net-probe --ignore-not-found >/dev/null 2>&1

echo -e "\n================ 巡检结果: PASS=$PASS FAIL=$FAIL ================"
[ "$FAIL" -eq 0 ] && echo -e "\033[32m>>> 集群健康度极佳\033[0m" || echo -e "\033[31m>>> 存在失败项，请逐个排查\033[0m"
