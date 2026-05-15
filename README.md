# v2ray-agent (精简加固版)

> **基于 [mack-a/v2ray-agent](https://github.com/mack-a/v2ray-agent) 修改**
> 原作者: [mack-a](https://github.com/mack-a) | 原项目遵循 AGPL-3.0 协议
> 本 fork 在原作基础上精简 + 安全加固 + 安装简化

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

Xray-core/sing-box 一键脚本快速安装（精简加固版）

## 相比原版的修改

### 🔒 安全加固
- **二进制完整性校验**: Xray-core / sing-box 下载后自动验证 SHA256
- **Reality short_id 随机化**: 每次安装随机生成，不再使用全局固定值
- **敏感文件权限**: 配置文件和私钥自动 `chmod 600`
- **移除信息泄露**: 删除硬编码邮箱
- **pipe-to-sh 修复**: 防止命令注入

### 📜 证书模块增强
- **DNSPod 支持**: 新增腾讯云 DNSPod DNS API
- **域名解析预验证**: 申请前检查域名 IP 是否指向本机
- **WARP 自动处理**: 申请证书时自动暂停/恢复 WARP
- **80 端口自动释放**: 释放被占用的 80 端口
- **随机邮箱生成**: 回车自动生成虚拟邮箱
- **三级域名支持**: `sub.domain.com` 格式
- **证书自动续期**: 每天 0 点 cron 检查
- **详细排错指南**: 6 种常见失败原因及解决方案

### ⚡ 安装简化
- **端口自动分配**: 每个协议独立随机端口（10000-65535），不再逐一询问
- **端口冲突检测**: 自动跳过已占用端口和保留端口（22/80/443/307 等）
- **路径自动生成**: 不再询问自定义路径，自动随机生成
- **安装流程**: 只需输入域名，其余全自动
- **移除 Naive / VMess+HTTPUpgrade**: 不稳定协议，已彻底移除

### ⚡ 新增功能
- **IP 配置管理（菜单 14）**: IPv4/IPv6 出站策略切换
- **退格键修复**: 修复部分终端退格键乱码

### 🧹 Bug修复（v3.5.17 全面审查）

**严重Bug修复:**
| Bug | 修复 |
|-----|------|
| `showAccounts` 被覆盖为空操作 | 从 git 历史恢复完整实现，修复账号显示和订阅系统失效 |
| x25519 密钥解析 grep 模式错误 | `PrivateKey`→`Private key`, `Password`→`Public key` |
| `initRealityClientServersName` if/elif 条件相同 | elif 条件改为 `-n`，修复死代码 |
| Hysteria2 上传/下载速度赋值反转 | 交换 `up_mbps`/`down_mbps` 赋值 |
| `unInstallSingBox` 无条件删除 config.json | 添加 `type` 非空检查 |
| nginx 裸调用阻塞脚本 | 改为 `nginx -t 2>&1` |
| systemd `$MAINPID` 被 bash 空展开 | 转义为 `\$MAINPID` |
| iptables 删除错误规则 | 反向排序行号 + 使用 `${line}` 替代硬编码 `1` |
| TUIC QR 码端口未定义 | `tuicPort`→`${port}` |
| TUIC Clash Meta SNI 设为邮箱 | 改为 `${currentHost}` |
| jq 语法缺少 `]` (trojan gRPC) | 补全闭合方括号 |
| `routingRule` 未定义 | 改为 `domainRules` |
| `selectCustomInstallType` elif 死代码 | 添加 `! grep ",2,"` 条件 |

**中等Bug修复:**
| Bug | 修复 |
|-----|------|
| 随机字符集缺少字母 `s` | `abcdefghijklmnopqrtuxyz`→`abcdefghijklmnopqrstuvwxyz` |
| `rm -rf` 通配符不展开 | 移除引号让 glob 生效 |
| `portHoppingMenu` 递归丢失 `type` 参数 | 添加 `"${type}"` |
| `installSingBox` 递归丢失 prereleaseStatus | 添加 `"$2"` |
| `rm` 不带 `-f` 选项 | 统一使用 `rm -f` |
| 脚本更新先删后下载 | 改为原子替换（先下载再覆盖） |
| grep 部分匹配导致去重错误 | 改用 `-qF` 固定字符串匹配 |
| Clash Meta DNS `1.12.12.12` 错误 | 改为 `223.6.6.6` |
| sing-box Trojan gRPC `insecure:true` | 改为 `false` |
| `warpRoutingReg` 无效时未退出 | 添加 `return 1` |
| `readHysteriaPortHopping` 函数缺失 | 从 git 历史恢复 |
| nginx 配置文件缺失 | 手动创建 `subscribe.conf` + `alone.conf` |

**原有Bug修复（保留）:**
| Bug | 修复 |
|-----|------|
| `refreshIP`(菜单 14) jq 引用错误 | `--arg` 传参替代内联展开 |
| `releasePort80` 管道到 `sh` | 改用 `xargs -r kill -9` |
| IP 正则匹配误判 | `=~` → `==` |
| Debian 检测用错文件 | `/etc/issue` → `/etc/os-release` |
| `magenta` 颜色码错误 | `31` → `35` |
| 通配符证书检测失效 | glob 改用展开模式 |
| 证书 crontab 格式错误 | 移除多余 `root` 字段 |
| IPv6 域名正则误匹配 | 空正则改为正确检测 |
| WARP 状态未初始化 | 添加 `warpRestartNeeded=false` |
| UUID 变量名错误 | `uuid` → `newUUID` |
| 证书续期缺少 WARP 处理 | `renewalTLS` 添加 WARP 恢复 |
| 退格键乱码 | 改用 `printf '\\177'` |

### 🧹 代码清理
- **移除推广广告**: 删除主菜单 VPS 推广区
- **移除 Naive / VMess+HTTPUpgrade**: 不稳定协议，移除 964 行代码
- **移除死代码**: `initSingBoxRouteConfig`、`checkRealityDest`、`initXrayFrontingConfig` 等

## 功能

*   **多核心支持:** Xray-core / sing-box（二选一）
*   **支持协议:** VLESS+TCP, VLESS+WS, Trojan+TCP, Trojan+gRPC, VMess+WS, Hysteria2, Tuic, AnyTLS, VLESS+Reality+Vision, VLESS+Reality+gRPC, VLESS+XHTTP
*   **自动TLS:** Let's Encrypt / Buypass（支持 Cloudflare / 阿里云 / DNSPod DNS API）
*   **自动端口:** 每个协议自动分配独立随机端口，跳过保留端口和已占用端口
*   **IP 配置管理:** IPv4/IPv6 出站策略动态切换
*   **订阅支持:** Clash Meta / sing-box 格式
*   **分流管理:** WARP / IPv6 / Socks5 / DNS / SNI 反向代理

## 快速开始

### 安装脚本版

```bash
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/kzb12580/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
```

安装过程中只需要输入域名，端口/path/证书邮箱全部自动处理。

### 使用

安装后，运行以下命令可再次打开管理菜单:

```bash
vasma
```

### 安装流程说明

安装时交互内容已大幅简化：

| 项目 | 交互内容 |
|------|---------|
| **主菜单** | 选择安装方式（1.全量 / 2.自选 / 3.无域名Reality） |
| **核心选择** | Xray-core / sing-box |
| **域名** | 输入域名（用于 TLS 证书） |
| **端口** | ✅ 自动分配，每个协议独立随机端口 |
| **路径** | ✅ 自动随机生成 |
| **证书邮箱** | 可选，回车自动生成虚拟邮箱 |
| **证书厂商** | 可选，回车默认 Let's Encrypt |
| **DNS API** | 可选，根据需要填写 |

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
