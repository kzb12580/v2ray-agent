#!/usr/bin/env bash
# 发送IP变更邮件通知
# 使用前请设置 NOTIFY_EMAIL 环境变量，或修改下方默认值
# 原作者: mack-a (https://github.com/mack-a/v2ray-agent)

NOTIFY_EMAIL="${NOTIFY_EMAIL:-}"
if [[ -z "${NOTIFY_EMAIL}" ]]; then
    echo "错误: 未设置 NOTIFY_EMAIL 环境变量，跳过邮件通知"
    echo "用法: NOTIFY_EMAIL=your@email.com bash send_email.sh"
    exit 1
fi

touch /var/local/mail.log

currentIP=$(curl -s -4 whatismyip.akamai.com 2>/dev/null)
if [[ -z "${currentIP}" ]]; then
    echo "无法获取当前IP"
    exit 1
fi

historyIP=$(cat /var/local/mail.log 2>/dev/null)
if [[ "${currentIP}" == "${historyIP}" ]]; then
    echo "IP未变更，不发送邮件"
    exit 0
fi

echo "${currentIP}" | mail -s "VPS IP变更: ${currentIP}" "${NOTIFY_EMAIL}"
echo "${currentIP}" > /var/local/mail.log
echo "已发送IP变更通知到 ${NOTIFY_EMAIL}"
