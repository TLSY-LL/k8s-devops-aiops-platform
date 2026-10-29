#!/bin/bash
# 1. 清理系统日志，仅保留最近 3 天
journalctl --vacuum-time=3d > /dev/null 2>&1

# 2. 清理已退出/被删除的 Pod 遗留日志 (保留 3 天内的日志)
find /var/log/pods -type f -mtime +3 -exec truncate -s 0 {} \; 2>/dev/null
find /var/log/containers -type l -mtime +3 -delete 2>/dev/null

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 日志清理完成" >> /var/log/log-cleanup.log
