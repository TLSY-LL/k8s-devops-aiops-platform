#!/bin/bash
REPORT="/root/k8s-deploy/10-jiance/Credentials-Card.md"
echo "# Version A 账号密码与域名资产清单" > $REPORT
echo "> 注意：请妥善保管此文件，切勿泄露。" >> $REPORT

echo -e "\n## 🗺️ 域名与 IP 映射" >> $REPORT
echo "请将以下内容加入 Windows 的 hosts 文件：" >> $REPORT
echo '```text' >> $REPORT
echo "192.168.148.241  gitlab.kubex.com" >> $REPORT
echo "192.168.148.242  grafana.kubex.com" >> $REPORT
echo "192.168.148.243  alertmanager.kubex.com" >> $REPORT
echo "192.168.148.244  prometheus.kubex.com" >> $REPORT
echo "192.168.148.245  kuboard.kubex.com" >> $REPORT
echo "192.168.148.246  argocd.kubex.com" >> $REPORT
echo "192.168.148.247  harbor.kubex.com" >> $REPORT
echo '```' >> $REPORT

echo -e "\n## 🔐 各服务账号与密码" >> $REPORT
echo "| 服务名称 | 访问地址 | 账号 | 密码 |" >> $REPORT
echo "| --- | --- | --- | --- |" >> $REPORT
echo "| GitLab | http://gitlab.kubex.com | root | Kx7#pQ2\$Lm9@vR4 |" >> $REPORT
echo "| Harbor | http://harbor.kubex.com | admin | Harbor12345 |" >> $REPORT
echo "| Kuboard | http://kuboard.kubex.com | admin | Kuboard123 |" >> $REPORT
echo "| ArgoCD | https://argocd.kubex.com | admin | o0QXvgjrdBFZNsIa |" >> $REPORT

# 动态获取 Grafana 密码
GRAFANA_PWD=$(kubectl get secret -n monitoring kube-prom-grafana -o jsonpath="{.data.admin-password}" 2>/dev/null | base64 -d)
echo "| Grafana | http://grafana.kubex.com | admin | ${GRAFANA_PWD:-获取失败} |" >> $REPORT

# 内部中间件密码（仅记录）
echo -e "\n## ⚙️ 内部中间件密码（不对公网开放）" >> $REPORT
echo "- PostgreSQL: \`gitlab\` / \`abcd1234\`" >> $REPORT
echo "- Redis: \`abcd1234\`" >> $REPORT
echo "- MinIO (Velero 备份): \`minioadmin\` / \`minioadmin123\`" >> $REPORT
