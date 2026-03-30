# opencli-natural-commands

> OpenClaw 技能：用自然语言操控 Bilibili (B站)、YouTube 和 Cursor IDE

不需要记命令，直接说人话，AI 自动翻译执行。

## 功能一览

### B站 (Bilibili)

| 你说的话 | 做什么 |
|---------|--------|
| "B站现在什么最火" | 查看热门视频 |
| "帮我在B站搜 AI 视频" | 搜索视频 |
| "我最近在B站看了什么" | 查看观看历史 |
| "把 BV1xxx 的字幕拿下来" | 获取视频字幕 |
| "下载B站视频 BV1xxx" | 下载视频到本地 |
| "看看这个UP主发了什么" | 查看UP主投稿 |
| "我的B站收藏夹" | 查看收藏 |
| "B站排行榜" | 全站排行 |
| "关注动态" | 关注的人发了什么 |

### YouTube 视频分析

| 你说的话 | 做什么 |
|---------|--------|
| "看看 kingshot 的 YouTube 视频总结游戏卖点" | 主题研究：搜索 → 批量分析 → AI 综合报告 |
| "帮我调研一下 XXX 话题" | 主题研究工作流 |
| "这个频道最近发了什么" | 频道浏览 |
| "分析一下这个YouTube视频" | 元数据+字幕 → AI 深度分析 |
| "对比这几个视频的观点" | 多视频 AI 对比分析 |
| "帮我把视频做成学习笔记" | AI 生成结构化笔记 |
| "翻译这个英文视频" | 获取字幕 → AI 翻译 |

### Cursor IDE

| 你说的话 | 做什么 |
|---------|--------|
| "Cursor 连上了吗" | 检查连接状态 |
| "让 Cursor 帮我写个爬虫" | 发消息给 AI |
| "看看 Cursor 回复了什么" | 读取对话 |
| "用 Composer 重构代码" | 打开 Composer |
| "把对话保存下来" | 导出为 Markdown |

---

## 安装指南（完整步骤）

### 第 1 步：安装 Node.js

需要 Node.js **>= 20.0.0**。

```bash
# 检查版本
node --version

# 如果没有或版本太低：
# Windows: 从 https://nodejs.org 下载 LTS 版本安装
# macOS:   brew install node
# Linux:   curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt install -y nodejs
```

### 第 2 步：安装 OpenCLI

```bash
npm install -g @jackwener/opencli
```

验证：
```bash
opencli --version
# 应显示版本号，如 1.4.0
```

### 第 3 步：安装 Browser Bridge 扩展（B站 + YouTube 必需）

这个 Chrome 扩展让 opencli 能通过浏览器操作网站。

1. 去 [opencli Releases 页面](https://github.com/jackwener/opencli/releases) 下载最新的 `opencli-extension.zip`
2. 解压到一个固定目录（不要放在下载文件夹，以后不能删）：
   ```
   # 推荐路径
   Windows: D:\tools\opencli-extension\
   macOS:   ~/tools/opencli-extension/
   Linux:   ~/tools/opencli-extension/
   ```
3. 打开 Chrome 浏览器，地址栏输入：`chrome://extensions`
4. 打开右上角的 **「开发者模式」** 开关
5. 点击 **「加载已解压的扩展程序」**
6. 选择解压后的文件夹
7. 确认看到 **「OpenCLI」** 扩展出现在列表中且已启用

验证：
```bash
opencli doctor
# 应显示:
# [OK] Daemon: running
# [OK] Extension: connected
# [OK] Connectivity: connected
```

> 如果 `opencli doctor` 显示 Extension not connected，请确保 Chrome 已打开且扩展已启用。daemon 会在第一次运行浏览器命令时自动启动。

### 第 4 步：登录目标网站

在 Chrome 中打开并登录你需要使用的网站：

| 功能 | 需要登录的网站 |
|------|-------------|
| B站命令 | [bilibili.com](https://www.bilibili.com) |
| YouTube 命令 | [youtube.com](https://www.youtube.com) |

> 登录一次即可，opencli 复用 Chrome 的 Cookie，不需要输入密码。

### 第 5 步：安装技能到 OpenClaw

确保 [OpenClaw](https://docs.openclaw.ai/) 已安装并运行。

**方式一：一键脚本（推荐）**

```bash
# Windows PowerShell
git clone https://github.com/zhangzeyu99-web/opencli-natural-commands.git
cd opencli-natural-commands
.\scripts\install.ps1

# Linux / macOS
git clone https://github.com/zhangzeyu99-web/opencli-natural-commands.git
cd opencli-natural-commands
bash scripts/install.sh
```

脚本会自动完成：检查 Node.js → 检查 opencli → 复制技能文件到 OpenClaw → 设置 Cursor 环境变量（Windows）→ 重启 Gateway

**方式二：克隆到技能目录**

```bash
# Linux / macOS
cd ~/.openclaw/workspace/skills/
git clone https://github.com/zhangzeyu99-web/opencli-natural-commands.git

# Windows PowerShell
cd "$env:USERPROFILE\.openclaw\workspace\skills\"
git clone https://github.com/zhangzeyu99-web/opencli-natural-commands.git
```

然后重启 Gateway：
```bash
openclaw gateway restart
```

**方式三：手动复制**

将整个仓库目录（包含 `SKILL.md` 和 `references/` 文件夹）复制到 OpenClaw 技能目录：

```bash
# Linux / macOS
cp -r opencli-natural-commands ~/.openclaw/workspace/skills/

# Windows PowerShell
Copy-Item -Recurse opencli-natural-commands "$env:USERPROFILE\.openclaw\workspace\skills\"
```

> **重要**：必须复制整个目录，不能只复制 SKILL.md。技能运行时需要读取 `references/` 下的详细参考文件。

验证技能已加载：
```bash
openclaw skills list | grep opencli
# 应显示: ✓ ready | 📦 opencli-natural-commands
```

### 第 6 步（可选）：配置 Cursor IDE 控制

如果你需要通过 opencli 控制 Cursor 编辑器：

**a) 设置环境变量**

```bash
# Windows PowerShell（永久生效）
[Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", "http://127.0.0.1:9226", "User")

# Linux / macOS
echo 'export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9226"' >> ~/.bashrc
source ~/.bashrc
```

**b) 修改 Cursor 启动方式**

Cursor 需要以调试端口启动才能被控制：

**Windows**：右键桌面上的 Cursor 快捷方式 → 属性 → 在「目标」末尾加上 ` --remote-debugging-port=9226` → 确定

**macOS**：
```bash
/Applications/Cursor.app/Contents/MacOS/Cursor --remote-debugging-port=9226
```

**Linux**：
```bash
cursor --remote-debugging-port=9226
```

**c) 验证**

重启 Cursor（从修改后的快捷方式启动），然后：
```bash
opencli cursor status
# 应显示: Connected
```

### 第 7 步（可选）：安装 yt-dlp

以下功能需要 yt-dlp：
- B站视频下载（`opencli bilibili download`）
- YouTube 字幕回退（当内置接口不可用时）

```bash
pip install yt-dlp

# 验证
yt-dlp --version
```

---

## 安装检查清单

完成安装后，用这个清单确认各功能可用：

| 检查项 | 命令 | 期望结果 |
|-------|------|---------|
| opencli 已安装 | `opencli --version` | 显示版本号 |
| 浏览器扩展已连接 | `opencli doctor` | 全部 OK |
| B站功能 | `opencli bilibili hot --limit 3` | 显示热门视频 |
| YouTube 功能 | `opencli youtube search "test" --limit 3` | 显示搜索结果 |
| Cursor 功能 | `opencli cursor status` | 显示 Connected |
| 技能已加载 | `openclaw skills list \| grep opencli` | 显示 ready |
| yt-dlp（可选） | `yt-dlp --version` | 显示版本号 |

---

## 命令速查

### B站

```bash
opencli bilibili hot --limit 10              # 热门视频
opencli bilibili search "关键词" --limit 10   # 搜索
opencli bilibili me                           # 我的信息
opencli bilibili favorite                     # 收藏夹
opencli bilibili history --limit 20           # 观看历史
opencli bilibili feed --limit 10              # 关注动态
opencli bilibili subtitle BVxxx               # 视频字幕
opencli bilibili ranking --limit 10           # 排行榜
opencli bilibili following --limit 20         # 关注列表
opencli bilibili user-videos UID --limit 10   # UP主视频
opencli bilibili download BVxxx --output ./   # 下载视频
```

### YouTube

```bash
opencli youtube search "关键词" --limit 10    # 搜索视频
opencli youtube video "URL或ID"               # 视频元数据（标题/播放量/描述/关键词等）
opencli youtube transcript "URL" --lang en    # 获取字幕
opencli youtube transcript "URL" --mode raw   # 原始时间戳模式
```

### Cursor

```bash
opencli cursor status                         # 连接状态
opencli cursor send "消息"                     # 发消息
opencli cursor ask "问题"                      # 问答（等回复）
opencli cursor read                           # 读对话
opencli cursor composer "指令"                 # Composer
opencli cursor model                          # 当前模型
opencli cursor extract-code                   # 提取代码
opencli cursor history                        # 对话历史
opencli cursor export --output ./export.md    # 导出对话
opencli cursor screenshot                     # 截图
```

### 输出格式

所有命令支持 `-f` 参数：

```bash
opencli bilibili hot -f json    # JSON
opencli bilibili hot -f yaml    # YAML
opencli bilibili hot -f md      # Markdown
opencli bilibili hot -f csv     # CSV
opencli bilibili hot -f table   # 表格（默认）
```

---

## 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| "Extension not connected" | Browser Bridge 未安装或 Chrome 未打开 | 检查 `chrome://extensions`，确保扩展已启用 |
| 返回空数据 | 目标网站登录过期 | 在 Chrome 中重新登录 bilibili.com / youtube.com |
| "OPENCLI_CDP_ENDPOINT is not set" | Cursor 环境变量未设置 | 按第 6 步设置环境变量 |
| "No inspectable targets" | Cursor 没有以调试端口启动 | 按第 6 步修改 Cursor 启动参数 |
| "yt-dlp not installed" | 未安装 yt-dlp | `pip install yt-dlp` |
| 并发执行报错断连 | 同时运行多个浏览器命令 | 技能已内置串行规则，此问题已自动处理 |

更多问题参见 [references/troubleshooting.md](references/troubleshooting.md)

## 安全说明

- OpenCLI 复用 Chrome 已有登录态，**不存储任何密码**
- 本地 daemon 仅绑定 `127.0.0.1`，外部不可访问
- 代码开源，经过安全审查：[jackwener/opencli](https://github.com/jackwener/opencli)
- 详细审查报告：[references/security-audit.md](references/security-audit.md)

## 项目结构

```
opencli-natural-commands/
├── SKILL.md                          # 技能入口（路由表，按需加载子模块）
├── references/
│   ├── bilibili-commands.md          # B站 12 条命令完整参考
│   ├── youtube-commands.md           # YouTube 命令 + 主题研究 + 频道浏览工作流
│   ├── cursor-commands.md            # Cursor 12 条命令完整参考
│   ├── troubleshooting.md            # 常见问题排查
│   └── security-audit.md            # 安全审查报告
├── scripts/
│   ├── install.ps1                   # Windows 一键安装
│   └── install.sh                    # Linux/macOS 一键安装
├── README.md
├── CHANGELOG.md
└── LICENSE
```

## 致谢

- [OpenCLI](https://github.com/jackwener/opencli) — 底层 CLI 引擎（jackwener）
- [OpenClaw](https://docs.openclaw.ai/) — AI Agent 平台

## License

MIT
