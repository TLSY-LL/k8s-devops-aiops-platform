# 🚀 TLSY-Cloud - 极简 K8s DevOps & AIOps 底座

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.36.5-blue.svg)](https://kubernetes.io/)
[![GitLab CI](https://img.shields.io/badge/CI-GitLab_Runner-orange.svg)](https://gitlab.com/)
[![Kaniko](https://img.shields.io/badge/Build-Kaniko-success.svg)](https://github.com/GoogleContainerTools/kaniko)
[![Harbor](https://img.shields.io/badge/Registry-Harbor-blueviolet.svg)](https://goharbor.io/)

本项目是一个集成了 **K8s 基础设施、GitLab CI/CD 自动化流水线、全站 HTTPS 安全网关、全栈监控告警，以及 AIOps 智能排障** 的轻量级云原生底座。

适用场景：中小型团队内部私有云、个人实验室、边缘计算节点。

## ✨ 核心特性

- **⚡ 极速部署**：提供标准化的 `Makefile` 与 `.env` 配置模板，一键拉起所有组件，告别散乱的 YAML。
- **🔒 全站安全**：基于 NGF 网关与 cert-manager，实现全域名 HTTPS 强制跳转与自签证书自动续期。
- **🛠️ 无痛 CI/CD**：抛弃重型 Jenkins，拥抱 GitLab Runner + Kaniko。无需特权模式，内置阿里云 Maven 加速，单 Pod 完成编译打包推镜像。
- **📊 全栈监控**：Prometheus + Grafana + Loki + Blackbox 完美组合，外部域名拨测与内部指标尽在掌握。
- **🤖 AIOps 副驾驶**：打通 Alertmanager -> n8n -> DeepSeek -> 控制台闭环，支持告警静默分析。
- **🛡️ 极限防雪崩**：所有组件均配置了合理的 Limits，并预设了 Kubelet `systemReserved` 与防 OOM 策略，适配低配物理机。

## 🚀 快速开始

### 1. 前置要求
- 至少 3 台节点（Master + Node1 + Node2），建议每台 4核 8G 内存起步。
- 已安装并初始化好 K8s 集群、Calico 网络与 NFS 存储。
- 集群内需能访问 `docker.1ms.run` 等国内加速源。

### 2. 一键部署

```bash
# 克隆项目
git clone https://github.com/TLSY-LL/TLSY-Cloud.git
cd TLSY-Cloud

# 复制配置模板并修改 (填入你的真实 IP、密码和域名)
cp .env.example .env
vim .env

# 一键渲染变量并拉起全部组件
make deploy

# 等待 2-3 分钟，查看组件健康状态
make status
