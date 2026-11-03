# K8s 运维工具箱使用文档 (10-jiance)

本目录包含合并重构后的三大核心脚本，用于日常巡检、报告生成和日志清理。

## 1. ops-check.sh (日常巡检)
**功能**：
- 检查节点状态（是否全 Ready）
- 检查全局异常 Pod（排除系统组件）
- 检查核心业务（GitLab、监控、Harbor）及缩容组件状态
- 检查 PVC 挂载情况
- 检查节点资源消耗
- 运行临时 Pod 进行 CoreDNS 解析和核心链路连通性测试
**用法**：`bash ops-check.sh`
**输出**：屏幕输出彩色 PASS/FAIL 结果。

## 2. ops-report.sh (报告生成)
**功能**：一键生成三份 Markdown 报告到当前目录。
- `Cluster-Health-Report.md`：集群健康基线报告
- `Cluster-Final-Audit.md`：封板前终极审计报告
- `Credentials-Card.md`：账号密码与域名资产清单
**用法**：`bash ops-report.sh`

## 3. ops-cleanup.sh (日志清理)
**功能**：清理系统日志与 Pod 遗留日志，仅保留最近 3 天。
**用法**：`bash ops-cleanup.sh`
建议：加入 Crontab 定期执行（如 `0 3 * * * /root/k8s-deploy/10-jiance/ops-cleanup.sh`）。
