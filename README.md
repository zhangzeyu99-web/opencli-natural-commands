# opencli-natural-commands

> OpenClaw Skill: 用自然语言操控 Cursor IDE、Bilibili、HackerNews、微博等 50+ 平台

不需要记命令，直接说人话，AI 自动翻译执行。基于 [opencli](https://github.com/jackwener/opencli) 引擎。

## 功能

### B站 (Bilibili)

| 你说的话 | 做什么 |
|---------|--------|
| "B站现在什么最火" | 查看热门视频 |
| "帮我在B站搜 AI 视频" | 搜索视频 |
| "把 BV1xxx 的字幕拿下来" | 获取视频字幕 |
| "下载B站视频 BV1xxx" | 下载视频到本地 |
| "看看这个UP主发了什么" | 查看UP主投稿 |
| "我的B站收藏夹" | 查看收藏 |

### YouTube 视频分析

| 你说的话 | 做什么 |
|---------|--------|
| "分析一下这个YouTube视频" | 元数据+字幕 → AI 内容分析 |
| "帮我把视频做成学习笔记" | AI 生成结构化笔记 |
| "翻译这个英文视频" | 获取字幕 → AI 翻译 |

### 50+ 平台数据源

HackerNews、V2EX、微博、小红书、知乎、微信读书、豆瓣、Reddit、Twitter、Medium、LinkedIn 等。

### Cursor IDE 控制

| 你说的话 | 做什么 |
|---------|--------|
| "让 Cursor 帮我写个爬虫" | 发消息给 AI |
| "用 Composer 重构代码" | 打开 Composer |
| "把对话保存下来" | 导出为 Markdown |

### 网页爬虫

- 公开网页正文提取（web_fetch）
- 反爬虫/Cloudflare 绕过（scrapling）
- 动态渲染页面抓取

### 网页截图

通过 CDP 直连 Chrome 截图，B站操作后可就地截图无需切换技能。

## v2.1.0 新特性

- **Stealth 反检测**：内置 7 项反检测补丁，CDP 连接时自动注入
- **50+ 平台**：新增 HackerNews (7命令)、微博搜索、V2EX 扩展、微信公众号下载
- **网页爬虫**：集成 scrapling 反爬虫能力
- **CDP 截图**：无需依赖 Gateway，直连 Chrome 截图

## 安装

### 一键安装（推荐）

```bash
# 克隆到 OpenClaw skills 目录
cd ~/.openclaw/workspace/skills/
git clone https://github.com/zhangzeyu99-web/opencli-natural-commands.git

# 重启 Gateway
openclaw gateway restart
```

### 前置依赖

```bash
# 1. 安装 opencli
npm install -g @jackwener/opencli

# 2. 安装 Browser Bridge 扩展
#    下载: https://github.com/jackwener/opencli/releases
#    在 chrome://extensions 中加载已解压的扩展

# 3. 启动 Chrome 调试模式
#    Windows:
#    & "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222
#    macOS:
#    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
#    Linux:
#    google-chrome --remote-debugging-port=9222

# 4. 设置环境变量
#    Windows: $env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9222"
#    Linux/macOS: export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9222"

# 5. (可选) 网页爬虫依赖
pip install "scrapling[fetchers]" websockets

# 6. (可选) 视频下载
pip install yt-dlp
```

### 配置 Cursor 控制

Cursor 需要以调试端口启动：

```bash
# 启动 Cursor 时添加参数
cursor --remote-debugging-port=9226

# 设置环境变量（Cursor 命令执行前切换）
# Windows: $env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9226"
# Linux/macOS: export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9226"
```

### 验证安装

```bash
opencli doctor          # 检查环境
opencli bilibili hot    # 测试 B站
opencli hackernews top  # 测试 HackerNews (无需浏览器)
```

## 与 chrome-browser-automation 的协调

本技能与 [chrome-browser-automation](https://github.com/zhangzeyu99-web/chrome-browser-automation) 共享同一个 Chrome CDP 端口 (9222)，职责分工：

| 任务 | 使用技能 |
|------|---------|
| B站/YouTube/Cursor/爬虫 | **opencli-natural-commands** (本技能) |
| 截图/AI搜索(Kimi/Gemini)/打开网页/表单 | **chrome-browser-automation** |

两者不得同时操作 Chrome，串行执行即可。

## 安全说明

- OpenCLI 复用 Chrome 已有登录态，**不存储任何密码**
- 本地 daemon 仅绑定 `127.0.0.1`，外部不可访问
- Stealth 补丁仅用于防检测，不修改页面内容
- 代码开源，经过安全审查：[jackwener/opencli](https://github.com/jackwener/opencli)

## 致谢

- [OpenCLI](https://github.com/jackwener/opencli) — 底层 CLI 引擎
- [OpenClaw](https://openclaw.com) — AI Agent 平台
- [scrapling](https://github.com/AhmedAltundas/scrapling) — 反爬虫框架

## License

MIT
