#!/bin/bash
REPORT="/root/k8s-deploy/10-jiance/Cluster-Health-Report.md"
echo "# K8s 集群健康与架构基线报告 (Version A)" > $REPORT
echo "> 生成时间：$(date '+%Y-%m-%d %H:%M:%S')" >> $REPORT

echo -e "\n## 1. 节点状态" >> $REPORT
echo '```text' >> $REPORT
kubectl get nodes -o wide >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 2. 核心业务与监控状态" >> $REPORT
echo '```text' >> $REPORT
kubectl get pods -n gitlab-app
kubectl get pods -n monitoring >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 3. 负载均衡与域名映射 (LoadBalancer)" >> $REPORT
echo '```text' >> $REPORT
kubectl get svc -A | grep LoadBalancer >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 4. 存储 PVC 状态" >> $REPORT
echo '```text' >> $REPORT
kubectl get pvc -A >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 5. 节点资源利用率" >> $REPORT
echo '```text' >> $REPORT
kubectl top nodes >> $REPORT
echo '```' >> $REPORT

echo "✅ 基线报告已生成：$REPORT"
