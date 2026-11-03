#!/bin/bash
REPORT_DIR="/root/k8s-deploy/10-jiance"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 健康基线报告
HEALTH="$REPORT_DIR/Cluster-Health-Report.md"
echo "# K8s 集群健康与架构基线报告" > $HEALTH
echo "> 生成时间：$DATE" >> $HEALTH
echo -e "\n## 1. 节点状态" >> $HEALTH
echo '```text' >> $HEALTH
kubectl get nodes -o wide >> $HEALTH
echo '```' >> $HEALTH
echo -e "\n## 2. 核心业务与监控状态" >> $HEALTH
echo '```text' >> $HEALTH
kubectl get pods -n gitlab-app >> $HEALTH
kubectl get pods -n monitoring >> $HEALTH
echo '```' >> $HEALTH
echo -e "\n## 3. 负载均衡与域名映射" >> $HEALTH
echo '```text' >> $HEALTH
kubectl get svc -A | grep LoadBalancer >> $HEALTH
echo '```' >> $HEALTH
echo -e "\n## 4. 存储 PVC 状态" >> $HEALTH
echo '```text' >> $HEALTH
kubectl get pvc -A >> $HEALTH
echo '```' >> $HEALTH
echo -e "\n## 5. 节点资源利用率" >> $HEALTH
echo '```text' >> $HEALTH
kubectl top nodes >> $HEALTH
echo '```' >> $HEALTH
echo "✅ 健康基线报告已生成：$HEALTH"

# 封板前终极审计报告
AUDIT="$REPORT_DIR/Cluster-Final-Audit.md"
echo "# K8s 集群封板前终极审计报告" > $AUDIT
echo "> 时间: $DATE" >> $AUDIT
echo -e "\n## 1. 节点资源与负载" >> $AUDIT
echo '```text' >> $AUDIT
kubectl top nodes >> $AUDIT
echo '```' >> $AUDIT
echo -e "\n## 2. 异常 Pod 检测 (排除系统组件)" >> $AUDIT
echo '```text' >> $AUDIT
kubectl get pods -A | grep -vE "Running|Completed" | grep -vE "kube-system|calico|metallb|nginx-gateway|tigera" || echo "✅ 无异常 Pod" >> $AUDIT
echo '```' >> $AUDIT
echo -e "\n## 3. 所有工作负载状态" >> $AUDIT
echo '```text' >> $AUDIT
kubectl get pods -A | grep -E "gitlab-app|monitoring|harbor|kuboard|argocd|velero" >> $AUDIT
echo '```' >> $AUDIT
echo -e "\n## 4. 持久化存储 (PVC) 状态" >> $AUDIT
echo '```text' >> $AUDIT
kubectl get pvc -A >> $AUDIT
echo '```' >> $AUDIT
echo -e "\n## 5. 当前目录代码结构" >> $AUDIT
echo '```text' >> $AUDIT
ls -lR /root/k8s-deploy/{09-gitlab,10-jiance,11-monitoring,12-harbor,13-kuboard,14-cert-manager,15-velero,16-argocd} | grep -E ":$|.yaml$|.sh$|.tgz$" >> $AUDIT
echo '```' >> $AUDIT
echo "✅ 封板审计报告已生成：$AUDIT"

# 凭证清单
CRED="$REPORT_DIR/Credentials-Card.md"
echo "# 账号密码与域名资产清单" > $CRED
echo "> 注意：请妥善保管此文件，切勿泄露。" >> $CRED
echo -e "\n## 🗺️ 域名与 IP 映射" >> $CRED
echo "请将以下内容加入 Windows 的 hosts 文件：" >> $CRED
echo '```text' >> $CRED
echo "192.168.148.241  gitlab.${DOMAIN_SUFFIX}" >> $CRED
echo "192.168.148.242  grafana.${DOMAIN_SUFFIX}" >> $CRED
echo "192.168.148.243  alertmanager.${DOMAIN_SUFFIX}" >> $CRED
echo "192.168.148.244  prometheus.${DOMAIN_SUFFIX}" >> $CRED
echo "192.168.148.245  kuboard.${DOMAIN_SUFFIX}" >> $CRED
echo "192.168.148.246  argocd.${DOMAIN_SUFFIX}" >> $CRED
echo "192.168.148.247  harbor.${DOMAIN_SUFFIX}" >> $CRED
echo '```' >> $CRED
echo -e "\n## 🔐 各服务账号与密码" >> $CRED
echo "| 服务名称 | 访问地址 | 账号 | 密码 |" >> $CRED
echo "| --- | --- | --- | --- |" >> $CRED
echo "| GitLab | http://gitlab.${DOMAIN_SUFFIX} | root | Kx7#pQ2\$Lm9@vR4 |" >> $CRED
echo "| Harbor | http://harbor.${DOMAIN_SUFFIX} | admin | ${HARBOR_ADMIN_PASSWORD} |" >> $CRED
echo "| Kuboard | http://kuboard.${DOMAIN_SUFFIX} | admin | Kuboard123 |" >> $CRED
echo "| ArgoCD | https://argocd.${DOMAIN_SUFFIX} | admin | o0QXvgjrdBFZNsIa |" >> $CRED
GRAFANA_PWD=$(kubectl get secret -n monitoring kube-prom-grafana -o jsonpath="{.data.admin-password}" 2>/dev/null | base64 -d)
echo "| Grafana | http://grafana.${DOMAIN_SUFFIX} | admin | ${GRAFANA_PWD:-获取失败} |" >> $CRED
echo -e "\n## ⚙️ 内部中间件密码（不对公网开放）" >> $CRED
echo "- PostgreSQL: \`gitlab\` / \`abcd1234\`" >> $CRED
echo "- Redis: \`abcd1234\`" >> $CRED
echo "- MinIO (Velero 备份): \`minioadmin\` / \`minioadmin123\`" >> $CRED
echo "✅ 凭证清单已生成：$CRED"
