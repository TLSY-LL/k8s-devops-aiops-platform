#!/bin/bash
echo "🚨 触发集群急救程序！"

echo "1. 降级非核心业务，释放 CPU 压力..."
kubectl scale deploy -n harbor harbor-jobservice --replicas=0 2>/dev/null || true
kubectl scale deploy -n monitoring kube-prom-grafana --replicas=0 2>/dev/null || true
kubectl scale deploy -n tlsy-aiops tlsy-aiops --replicas=0 2>/dev/null || true

echo "2. 重启底层容器运行时和 Kubelet..."
systemctl restart containerd
systemctl restart kubelet

echo "3. 强制清理导致死锁的 Calico 和 Scheduler 僵尸..."
kubectl delete pods -n calico-system --all --force --grace-period=0 2>/dev/null || true
crictl ps -a | grep kube-scheduler | awk '{print $1}' | xargs -r crictl rm -f

echo "✅ 急救操作执行完毕，请等待 2 分钟观察节点状态。"
