import requests
import json
import base64

GRAFANA_URL = "http://grafana.kubex.com"
USER = "admin"
PASS = "6vZeL7LDENqXrE0oK2FXNHlJXpkZ4nxXRzN8UGDK" # 请替换为你实际的 Grafana 密码
AUTH_HEADER = {
    "Authorization": "Basic " + base64.b64encode(f"{USER}:{PASS}".encode()).decode(),
    "Content-Type": "application/json",
    "X-Disable-Provenance": "true" # 允许在 UI 中编辑
}

# ==========================================
# 1. 创建中文通知模板 (Notification Template)
# ==========================================
template_name = "chinese-custom-template"
template_content = """{{ define "chinese_custom_alert" }}
{{- if eq .Status "firing" -}}
【🔥 告警触发】{{ .CommonLabels.alertname }}
{{- else -}}
【✅ 告警恢复】{{ .CommonLabels.alertname }}
{{- end -}}

**告警详情**
- **告警级别**: {{ .CommonLabels.severity }}
- **触发时间**: {{ range .Alerts }}{{ .StartsAt.Format "2006-01-02 15:04:05" }}{{ end }}
- **当前状态**: {{ .Status }}

**触发实例**
{{ range .Alerts -}}
- **实例**: {{ .Labels.instance }}
  **描述**: {{ .Annotations.description }}
  **当前值**: {{ .Value }}
{{ end }}

> 请及时登录 Grafana 查看详情: {{ .ExternalURL }}
{{ end }}"""

template_payload = [{
    "name": template_name,
    "template": template_content
}]

print("正在创建中文通知模板...")
res = requests.put(f"{GRAFANA_URL}/api/v1/provisioning/templates/{template_name}", headers=AUTH_HEADER, json=template_payload)
print(res.status_code, res.text)

# ==========================================
# 2. 创建 Contact Point (关联邮件渠道和中文模板)
# ==========================================
cp_name = "163-Email-Auto"
cp_payload = {
    "name": cp_name,
    "type": "email",
    "settings": {
        "addresses": "Cube1109@163.com",
        "singleEmail": True,
        "message": '{{ template "chinese_custom_alert" . }}' # 绑定中文模板
    },
    "disableResolveMessage": False
}

print("\n正在创建邮件 Contact Point...")
res = requests.post(f"{GRAFANA_URL}/api/v1/provisioning/contact-points", headers=AUTH_HEADER, json=cp_payload)
print(res.status_code, res.text)

# ==========================================
# 3. 创建自动触发的测试告警规则 (使用 TestData 数据源)
# ==========================================
# 获取 TestData 数据源的 UID
res_ds = requests.get(f"{GRAFANA_URL}/api/datasources", headers=AUTH_HEADER)
testdata_uid = next((ds["uid"] for ds in res_ds.json() if ds["type"] == "testdata"), None)

if not testdata_uid:
    print("未找到 TestData 数据源，无法创建自动触发的告警。")
else:
    alert_payload = {
        "title": "自动触发的中文测试告警",
        "ruleGroup": "auto-test-group",
        "folderUID": "general", # 默认文件夹
        "condition": "C",
        "data": [
            {
                "refId": "A",
                "relativeTimeRange": {"from": 600, "to": 0},
                "datasourceUid": testdata_uid,
                "model": {
                    "scenarioId": "predictable_pulse",
                    "refId": "A"
                }
            },
            {
                "refId": "B",
                "relativeTimeRange": {"from": 600, "to": 0},
                "datasourceUid": "__expr__",
                "model": {
                    "type": "reduce",
                    "expression": "A",
                    "reducer": "last",
                    "refId": "B"
                }
            },
            {
                "refId": "C",
                "relativeTimeRange": {"from": 600, "to": 0},
                "datasourceUid": "__expr__",
                "model": {
                    "type": "threshold",
                    "expression": "B",
                    "conditions": [{
                        "evaluator": {"type": "gt", "params": [0.5]},
                        "operator": {"type": "and"},
                        "query": {"params": ["B"]},
                        "reducer": {"type": "last", "params": []},
                        "type": "query"
                    }],
                    "refId": "C"
                }
            }
        ],
        "noDataState": "NoData",
        "execErrState": "Error",
        "for": "0s", # 立即触发
        "annotations": {
            "description": "这是一个自动触发的中文测试告警邮件。"
        },
        "labels": {
            "severity": "warning",
            "instance": "k8s-master"
        },
        "isPaused": False
    }

    print("\n正在创建自动触发的测试告警规则...")
    res = requests.post(f"{GRAFANA_URL}/api/v1/provisioning/alert-rules", headers=AUTH_HEADER, json=alert_payload)
    print(res.status_code, res.text)

print("\n✅ 所有配置已通过 API 自动完成！请检查你的 163 邮箱。")
