
📦 TLSY-Cloud 部署指南与组件清单
核心组件版本
组件	版本	作用
Kubernetes	v1.36.5	容器编排核心
GitLab	17.6.0	源代码托管与 CI 调度
Harbor	v2.15.4	企业级私有镜像仓库
ArgoCD	v2.10.9	GitOps 声明式部署
Prometheus	v3.15.1	指标采集与告警规则
Grafana	v13.2.4	监控可视化大盘
N8N	latest	AIOps 自动化工作流
Kaniko	v1.23.1	无守护进程容器镜像构建
🚀 快速开始 (懒人式部署)
1. 前置要求
至少 3 台节点（Master + Node1 + Node2），建议每台 4核 8G 内存起步。

已安装并初始化好 K8s 集群、Calico 网络与 NFS 存储。

集群内需能访问 docker.1ms.run 等国内加速源。

2. 准备环境变量
克隆项目后，首先复制配置文件：

bash
cp .env.example .env
修改 .env 中的 IP 地址、密码和域名后缀，使其匹配你的真实环境。

3. 一键拉起
执行 Makefile 脚本（自动渲染 YAML 变量并 kubectl apply）：

bash
make deploy
4. 查看状态
bash
make status
📂 项目目录结构
text
TLSY-Cloud/
├── .env.example            # 环境变量模板
├── Makefile                # 一键部署命令
├── 01-infra/               # 底层基建 (Calico, MetalLB, NGF 等)
├── 02-devops/              # 流水线 (GitLab, Harbor, ArgoCD, Runner)
├── 03-monitoring/          # 可观测性 (Prometheus, Grafana, Alertmanager)
├── 04-aiops/               # 智能运维 (n8n, TLSY AIOps 控制台)
├── 05-apps/                # 测试应用与运维脚本
└── docs/                   # 架构图、使用文档、凭证清单
🛡️ 免责声明
本项目包含了 Kaniko 和特权容器配置，请务必在内网测试环境或个人开发环境使用。若用于生产环境，请务必修改所有默认密码，并配置完善的 RBAC 权限与网络隔离策略。

Made with ❤️ by TLSY-LL.
