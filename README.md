# ☁️ K8s DevOps & AIOps Intelligent Platform

> 一套基于 Kubernetes 的企业级 DevOps + AIOps 全栈云原生智能运维底座。
> 实现从代码提交、自动构建、镜像打包，到告警触发、大模型根因分析的完整闭环。

## 🌟 核心架构图
*(此处请把你画好的架构图/截图传上来，如果没有可以直接删掉这一行)*
![Architecture](这里待会儿教你上传图片)

## 🚀 三大核心模块

### 1. 全链路 CI/CD 自动化
- **技术栈**: GitLab + Jenkins + Harbor + ArgoCD
- **特性**: Jenkins 采用 K8s 动态 Agent，按需拉起 Pod 执行构建，零构建时零资源消耗。结合 ArgoCD 实现纯正 GitOps 风格的自动发布。

### 2. 全栈可观测性体系
- **技术栈**: Prometheus + Grafana + Loki + Alertmanager
- **特性**: 零侵入收集 K8s 集群核心指标与全量日志。定制化 Alertmanager 模板，支持中文精美 HTML 邮件告警。

### 3. 🤖 AIOps Copilot (运维副驾驶)
- **技术栈**: n8n + DeepSeek API + 自研 Python Web 控制台
- **特性**: 
  - **智能问答**：拥有 K8s 全量只读权限，可实时读取 Metrics 负载、Events 事件和异常 Pod。
  - **防幻觉引擎**：结合真实数据诊断，拒绝盲目猜测，并支持聊天历史持久化。
  - **告警自动分析**：Alertmanager 触发告警后，n8n 自动调度大模型进行分析，并将诊断报告推送到 Web 控制台。

## 📂 目录结构
- `00-08`: 底层基础环境搭建（网络、存储、负载均衡、监控）
- `09-16`: 核心组件部署（GitLab, Harbor, ArgoCD 等）
- `10-jiance`: 自研运维巡检与清理工具包
- `18-19`: Jenkins 与 n8n 自动化引擎
- `TLSYshuchutai`: 自研 AIOps 智能对话控制台

## 🚦 快速体验
> 注：此项目高度依赖本地硬件环境，如需复现，请按顺序 `kubectl apply` 对应目录下的 YAML 文件。

---
*Powered by TLSY-LL*
