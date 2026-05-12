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

### ⚡ 优化
- **安装URL**: 指向本仓库，后续更新从本仓库拉取
- **代码清理**: 移除部分死代码

## 功能

*   **多核心支持:** 支持 Xray-core 和 sing-box
*   **多协议支持:** 支持 VLESS, VMess, Trojan, Hysteria2, Tuic, NaiveProxy 等多种协议
*   **自动TLS:** 自动申请和续订 SSL 证书
*   **易于管理:** 提供简单的菜单来管理用户、端口和配置
*   **订阅支持:** 生成和管理订阅链接
*   **分流管理:** wireguard、IPv6、Socks5、DNS、SNI反向代理

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

### 安装Docker版

```bash
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/kzb12580/v2ray-agent/master/shell/docker_reality.sh" && chmod 700 /root/docker_reality.sh && /root/docker_reality.sh
```

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
本修改版仅在原作基础上进行安全加固，核心功能版权归原作者所有。
