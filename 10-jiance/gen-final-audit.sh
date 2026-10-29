#!/bin/bash
REPORT="/root/k8s-deploy/10-jiance/Cluster-Final-Audit.md"
echo "# K8s 集群封板前终极审计报告" > $REPORT
echo "> 时间: $(date '+%Y-%m-%d %H:%M:%S')" >> $REPORT

echo -e "\n## 1. 节点资源与负载" >> $REPORT
echo '```text' >> $REPORT
kubectl top nodes >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 2. 异常 Pod 检测 (排除系统组件)" >> $REPORT
echo '```text' >> $REPORT
kubectl get pods -A | grep -vE "Running|Completed" | grep -vE "kube-system|calico|metallb|nginx-gateway|tigera" || echo "✅ 无异常 Pod"
echo '```' >> $REPORT

echo -e "\n## 3. 所有工作负载状态" >> $REPORT
echo '```text' >> $REPORT
kubectl get pods -A | grep -E "gitlab-app|monitoring|harbor|kuboard|argocd|velero" >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 4. 持久化存储 (PVC) 状态" >> $REPORT
echo '```text' >> $REPORT
kubectl get pvc -A >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 5. 当前 09-16 目录代码结构" >> $REPORT
echo '```text' >> $REPORT
ls -lR /root/k8s-deploy/{09-gitlab,10-jiance,11-monitoring,12-harbor,13-kuboard,14-cert-manager,15-velero,16-argocd} | grep -E ":$|.yaml$|.sh$|.tgz$" >> $REPORT
echo '```' >> $REPORT
