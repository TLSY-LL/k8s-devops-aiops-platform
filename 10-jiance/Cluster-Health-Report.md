# K8s 集群健康与架构基线报告 (Version A)
> 生成时间：2026-10-28 12:40:25

## 1. 节点状态
```text
NAME         STATUS   ROLES           AGE     VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE           KERNEL-VERSION             CONTAINER-RUNTIME
k8s-master   Ready    control-plane   5d18h   v1.36.5   192.168.148.60   <none>        Ubuntu 26.04 LTS   7.0.0-38-generic (amd64)   containerd://2.4.2
k8s-node1    Ready    <none>          5d18h   v1.36.5   192.168.148.61   <none>        Ubuntu 26.04 LTS   7.0.0-38-generic (amd64)   containerd://2.4.2
k8s-node2    Ready    <none>          5d18h   v1.36.5   192.168.148.62   <none>        Ubuntu 26.04 LTS   7.0.0-38-generic (amd64)   containerd://2.4.2
```

## 2. 核心业务与监控状态
```text
NAME                                                    READY   STATUS    RESTARTS      AGE
alertmanager-kube-prom-kube-prometheus-alertmanager-0   2/2     Running   0             28m
kube-prom-grafana-864fd44469-n5wxc                      3/3     Running   9 (48m ago)   16h
kube-prom-kube-prometheus-operator-7d67966877-r5j58     1/1     Running   5 (52m ago)   17h
kube-prom-kube-state-metrics-fb44594c7-5gr7h            1/1     Running   6 (50m ago)   16h
kube-prom-prometheus-node-exporter-dm9jc                1/1     Running   2 (54m ago)   17h
kube-prom-prometheus-node-exporter-kvfv4                1/1     Running   1 (57m ago)   17h
kube-prom-prometheus-node-exporter-rl5nf                1/1     Running   1 (57m ago)   17h
loki-0                                                  2/2     Running   4 (49m ago)   17h
prometheus-kube-prom-kube-prometheus-prometheus-0       2/2     Running   2 (57m ago)   17h
promtail-2fllz                                          1/1     Running   1 (57m ago)   16h
promtail-7n2hh                                          1/1     Running   1 (57m ago)   16h
promtail-fbhtb                                          1/1     Running   1 (57m ago)   16h
```

## 3. 负载均衡与域名映射 (LoadBalancer)
```text
default          nginx-gateway-test-nginx                            LoadBalancer   10.109.192.82    192.168.148.240   80:32298/TCP                    5d16h
gitlab-app       gitlab                                              LoadBalancer   10.96.254.217    192.168.148.241   80:30763/TCP,22:32376/TCP       18h
kuboard          kuboard                                             LoadBalancer   10.108.162.31    192.168.148.245   80:32191/TCP                    16m
monitoring       kube-prom-grafana                                   LoadBalancer   10.111.210.101   192.168.148.242   80:31653/TCP                    17h
monitoring       kube-prom-kube-prometheus-alertmanager              LoadBalancer   10.103.240.91    192.168.148.243   9093:31342/TCP,8080:31263/TCP   16h
monitoring       kube-prom-kube-prometheus-prometheus                LoadBalancer   10.99.172.30     192.168.148.244   9090:30846/TCP,8080:31371/TCP   17h
```

## 4. 存储 PVC 状态
```text
NAMESPACE    NAME                                                                                                           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
gitlab-app   gitlab-pvc                                                                                                     Bound    pvc-84cda753-f959-4820-9516-8f4cecf9854b   20Gi       RWO            nfs-client     <unset>                 18h
kuboard      kuboard-data                                                                                                   Bound    pvc-54121a18-0f7c-4cc1-8422-751137e8652b   2Gi        RWO            nfs-client     <unset>                 16m
monitoring   alertmanager-kube-prom-kube-prometheus-alertmanager-db-alertmanager-kube-prom-kube-prometheus-alertmanager-0   Bound    pvc-84f6ad9d-cc17-4a10-a3f9-960297ab0060   2Gi        RWO            nfs-client     <unset>                 16h
monitoring   kube-prom-grafana                                                                                              Bound    pvc-6d5ef807-6682-4c50-86fc-e1572165233b   5Gi        RWO            nfs-client     <unset>                 17h
monitoring   prometheus-kube-prom-kube-prometheus-prometheus-db-prometheus-kube-prom-kube-prometheus-prometheus-0           Bound    pvc-8e75e025-72a8-40d2-a874-71d9d9d77dc2   10Gi       RWO            nfs-client     <unset>                 17h
monitoring   storage-loki-0                                                                                                 Bound    pvc-8bde5be4-2a4a-42aa-8a27-69d2267922c8   8Gi        RWO            nfs-client     <unset>                 17h
```

## 5. 节点资源利用率
```text
NAME         CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)   
k8s-master   629m         15%      4349Mi          69%         
k8s-node1    346m         8%       3796Mi          60%         
k8s-node2    283m         7%       2163Mi          34%         
```
