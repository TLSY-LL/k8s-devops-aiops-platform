# 🚀 TLSY-Cloud - 极简 K8s DevOps & AIOps 底座

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.36.5-blue.svg)](https://kubernetes.io/)
[![GitLab CI](https://img.shields.io/badge/CI-GitLab_Runner-orange.svg)](https://gitlab.com/)
[![Kaniko](https://img.shields.io/badge/Build-Kaniko-success.svg)](https://github.com/GoogleContainerTools/kaniko)
[![Harbor](https://img.shields.io/badge/Registry-Harbor-blueviolet.svg)](https://goharbor.io/)

本项目是一个集成了 **K8s 基础设施、GitLab CI/CD 自动化流水线、全站 HTTPS 安全网关、全栈监控告警，以及 AIOps 智能排障** 的轻量级云原生底座。

适用场景：中小型团队内部私有云、个人实验室、边缘计算节点。

---

## ✨ 核心特性

- **⚡ 极速部署**：提供标准化的 `Makefile` 与 `.env` 配置模板，一键拉起所有组件，告别散乱的 YAML。
- **🔒 全站安全**：基于 NGF 网关与 cert-manager，实现全域名 HTTPS 强制跳转与自签证书自动续期。
- **🛠️ 无痛 CI/CD**：抛弃重型 Jenkins，拥抱 GitLab Runner + Kaniko。无需特权模式，内置阿里云 Maven 加速，单 Pod 完成编译打包推镜像。
- **📊 全栈监控**：Prometheus + Grafana + Loki + Blackbox 完美组合，外部域名拨测与内部指标尽在掌握。
- **🤖 AIOps 副驾驶**：打通 Alertmanager -> n8n -> DeepSeek -> 控制台闭环，支持告警静默分析。
- **🛡️ 极限防雪崩**：所有组件均配置了合理的 Limits，并预设了 Kubelet `systemReserved` 与防 OOM 策略，适配低配物理机。

---

## 🗺️ 核心架构图

```mermaid
flowchart TB
    subgraph "接入层"
        A[MetalLB 负载均衡] --> B[NGF 网关 + cert-manager 证书]
    end

    subgraph "K8s 底座层"
        C[containerd 容器运行时] --> D[Kubernetes 集群 1.36.5]
        D --> E[Calico 容器网络]
        D --> F[NFS 持久化存储]
        D --> G[Metrics Server]
    end

    subgraph "流水线层"
        H[GitLab 代码仓库] --> I[GitLab Runner 动态执行]
        I --> J[Kaniko 无特权镜像构建]
        J --> K[Harbor 企业级镜像仓库]
        K --> L[ArgoCD GitOps 发布]
    end

    subgraph "可观测性层"
        M[Prometheus 指标采集] --> N[Grafana 可视化大盘]
        O[Loki + Promtail 日志聚合] --> N
        P[Blackbox 黑盒域名拨测] --> M
        M --> Q[Alertmanager 告警降噪]
    end

    subgraph "AIOps 层"
        R[n8n 自动化编排] --> S[DeepSeek 大模型分析]
        S --> T[TLSYshuchutai 智能控制台]
    end

    B --> D
    L --> D
    D --> M
    D --> O
    Q --> R
👉 点击查看完整的组件清单与一键部署指南 (INSTALL.md)
