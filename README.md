# v2ray-agent (安全加固版)

> **基于 [mack-a/v2ray-agent](https://github.com/mack-a/v2ray-agent) 修改**
> 原作者: [mack-a](https://github.com/mack-a) | 原项目遵循 AGPL-3.0 协议
> 本fork在原作基础上进行了安全加固和优化，详见下方修改说明

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

Xray-core/sing-box 一键脚本快速安装（安全加固版）

## 相比原版的修改

### 🔒 安全加固
- **二进制完整性校验**: Xray-core / sing-box 下载后自动验证SHA256
- **Reality short_id随机化**: 不再使用全局固定值，每次安装随机生成
- **敏感文件权限**: 配置文件和私钥自动设置 `chmod 600`
- **移除信息泄露**: 删除 send_email.sh 中的硬编码邮箱
- **错误处理增强**: 关键步骤添加错误检查

### 📜 证书模块增强（整合自 acme-yg）
- **DNSPod 支持**: 新增腾讯云 DNSPod DNS API 申请证书
- **IPv6 自动检测**: 自动识别纯IPv6/双栈/纯IPv4 VPS
- **域名解析验证**: 申请证书前验证域名是否正确解析到本机IP
- **WARP 自动处理**: 申请证书时自动暂停/恢复 WARP
- **80端口自动释放**: 申请证书前自动释放被占用的80端口
- **随机邮箱生成**: 回车自动生成虚拟邮箱，无需手动输入
- **Freenom 域名检测**: 检测免费域名并提示风险
- **三级域名支持**: 支持 `sub.domain.com` 格式的三级域名
- **证书自动续期**: cron 定时任务自动续期（每天0点检查）
- **证书卸载**: 支持完全卸载 acme.sh 和证书文件
- **详细排错指南**: 证书申请失败时提供详细排错步骤

### ⚡ 新增功能
- **IP配置管理（菜单14）**: 支持 IPv4/IPv6 出站策略切换
  - IPv4 优先出站
  - IPv6 优先出站
  - 仅 IPv4 出站
  - 仅 IPv6 出站
  - 自动更新 sing-box/xray 配置文件
- **退格键修复**: 修复部分终端下退格键显示异常字符的问题
- **安装URL**: 指向本仓库，后续更新从本仓库拉取

### 🧹 代码清理
- **移除推广广告**: 删除主菜单中的VPS推广区
- **移除死代码**: 清理 `initSingBoxRouteConfig`、`checkRealityDest`、`initXrayFrontingConfig` 等未使用函数（100+行）
- **Bug修复**:
  - 修复 `initXrayClients` 新用户UUID为空的问题
  - 修复 `releasePort80` 返回值被忽略的问题
  - 修复 Debian 系统检测用错文件（`/etc/issue` → `/etc/os-release`）
  - 修复 `magenta` 颜色代码错误
  - 修复 `refreshIP` 跳过缺少 `domain_strategy` 配置的问题
  - 修复通配符证书检测失效（`[[ ]]` 内通配符不展开）
  - 修复证书自动续期 crontab 格式错误
  - 修复 IPv6-only VPS 域名验证误判（空正则匹配一切）

## 功能

*   **多核心支持:** 支持 Xray-core 和 sing-box
*   **多协议支持:** 支持 VLESS, VMess, Trojan, Hysteria2, Tuic, AnyTLS, XHTTP 等多种协议
*   **自动TLS:** 自动申请和续订 SSL 证书（支持 Let's Encrypt / Buypass）
*   **DNS API**: 支持 Cloudflare / 阿里云 / 腾讯云 DNSPod DNS API
*   **易于管理:** 提供简单的菜单来管理用户、端口和配置
*   **订阅支持:** 生成和管理订阅链接（支持 Clash / SFA / sing-box 格式）
*   **分流管理:** wireguard、IPv6、Socks5、DNS、SNI反向代理
*   **IP配置管理:** 支持 IPv4/IPv6 出站策略动态切换

## 快速开始

### 安装脚本版

```bash
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/kzb12580/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
```

### 使用

安装后，运行以下命令可再次打开管理菜单:

```bash
vasma
```

### 安装Docker版（仅Reality）

```bash
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/kzb12580/v2ray-agent/master/shell/docker_reality.sh" && chmod 700 /root/docker_reality.sh && /root/docker_reality.sh
```

Docker版支持：
- VLESS Reality Vision
- VLESS XHTTP
- 无需域名，无需证书
- 数据持久化：`/etc/v2ray-agent/docker/`

## 菜单说明

| 编号 | 功能 | 说明 |
|------|------|------|
| 1 | 安装/重新安装 | 全量安装所有协议 |
| 2 | 任意组合安装 | 自选协议组合 |
| 3 | 一键无域名Reality | 无需域名的Reality安装 |
| 4 | Hysteria2管理 | 端口、速度、密码管理 |
| 5 | REALITY管理 | 密钥、SNI管理 |
| 6 | Tuic管理 | 端口、密码管理 |
| 7 | 用户管理 | 添加/删除用户、查看订阅 |
| 8 | 伪装站管理 | 更换伪装网站 |
| 9 | 证书管理 | 申请/续期/卸载证书 |
| 10 | CDN节点管理 | Cloudflare CDN优选 |
| 11 | 分流工具 | WARP/IPv6/Socks5/DNS/SNI分流 |
| 12 | 添加新端口 | 多端口复用 |
| 13 | BT下载管理 | BT下载分流 |
| 14 | IP配置管理 | IPv4/IPv6出站策略切换 |
| 15 | 域名黑名单 | 屏蔽指定域名 |
| 16 | core管理 | Xray/sing-box 版本切换 |
| 17 | 更新脚本 | 更新到最新版 |
| 18 | 安装BBR | BBR+FQ加速 |
| 20 | 卸载脚本 | 完全卸载 |

## 文档和指南

*   [八合一脚本从入门到精通](https://www.v2ray-agent.com/archives/1710141233)
*   [脚本快速搭建教程](https://www.v2ray-agent.com/archives/1682491479771)
*   [脚本使用注意事项](https://www.v2ray-agent.com/archives/1679931532764)
*   [脚本异常处理](https://www.v2ray-agent.com/archives/1684115970026)

## 社区与支持

*   **原作者Telegram:** [频道](https://t.me/v2rayAgentChannel) | [群组](https://t.me/technologyshare)
*   **原作者网站:** [官网](https://www.v2ray-agent.com/) | [备用](https://www.592083.xyz/)
*   **原作者X:** [链接](https://x.com/v2rayagent)

## 致谢

感谢 [mack-a](https://github.com/mack-a) 开发的 [v2ray-agent](https://github.com/mack-a/v2ray-agent) 原项目。
本修改版仅在原作基础上进行安全加固和功能增强，核心功能版权归原作者所有。
