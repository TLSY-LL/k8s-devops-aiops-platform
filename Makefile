.PHONY: help init deploy status

help:
	@echo "🚀 TLSY-Cloud - 极简 K8s DevOps & AIOps 底座"
	@echo "用法:"
	@echo "  make init      生成并检查 .env 配置"
	@echo "  make deploy    一键渲染变量并部署所有组件"
	@echo "  make status    查看集群异常状态"

init:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✅ 已生成 .env 文件，请修改里面的 IP 和密码后，再执行 make deploy"; \
	else \
		echo "⚠️ .env 文件已存在，直接使用。"; \
	fi

deploy: init
	@echo "🚀 开始加载 .env 并部署..."
	@set -a && . ./.env && set +a && \
	for dir in 01-infra 02-devops 03-monitoring 04-aiops 05-apps; do \
		if [ -d "$$dir" ]; then \
			echo "📦 正在部署 $$dir ..."; \
			find $$dir -name "*.yaml" -o -name "*.yml" | while read file; do \
				envsubst < $$file | kubectl apply -f -; \
			done \
		fi \
	done
	@echo "🎉 部署完成！运行 make status 查看状态。"

status:
	@echo "📊 集群异常 Pod 检查："
	@kubectl get pods -A | grep -vE "Running|Completed" || echo "✅ 全部组件正常运行"
