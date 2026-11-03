# 🚀 TLSY-Cloud - 极简 K8s DevOps & AIOps 底座

[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.36.5-blue.svg)](https://kubernetes.io/)
[![GitLab CI](https://img.shields.io/badge/CI-GitLab_Runner-orange.svg)](https://gitlab.com/)
[![Kaniko](https://img.shields.io/badge/Build-Kaniko-success.svg)](https://github.com/GoogleContainerTools/kaniko)
[![Harbor](https://img.shields.io/badge/Registry-Harbor-blueviolet.svg)](https://goharbor.io/)

本项目是一个集成了 **K8s 基础设施、GitLab CI/CD 自动化流水线、全站 HTTPS 安全网关、全栈监控告警，以及 AIOps 智能排障** 的轻量级云原生底座。

适用场景：中小型团队内部私有云、个人实验室、边缘计算节点。

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
