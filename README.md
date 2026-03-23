# opencli-natural-commands

> OpenClaw 技能：用自然语言操控 Cursor IDE 和 Bilibili (B站)

不需要记命令，直接说人话，AI 自动翻译执行。

## 功能

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
| "在YouTube搜 AI agent" | 搜索视频 |
| "看看这个YouTube视频的信息" | 获取元数据（播放量/点赞/描述等） |
| "把这个视频的字幕拿下来" | 获取字幕/转录文本 |
| "分析一下这个YouTube视频" | 元数据+字幕 → AI 内容分析 |
| "帮我把视频做成学习笔记" | AI 生成结构化笔记 |
| "翻译这个英文视频" | 获取字幕 → AI 翻译 |
| "整理成会议纪要" | 字幕+说话人 → 纪要格式 |
| "对比分析这几个视频" | 多视频字幕 → AI 观点对比 |
| "剪辑精华片段" | 联动 youtube-clipper 技能 |

### Cursor IDE

| 你说的话 | 做什么 |
|---------|--------|
| "Cursor 连上了吗" | 检查连接状态 |
| "让 Cursor 帮我写个爬虫" | 发消息给 AI |
| "看看 Cursor 回复了什么" | 读取对话 |
| "用 Composer 重构代码" | 打开 Composer |
| "把对话保存下来" | 导出为 Markdown |
| "Cursor 用的什么模型" | 查看当前模型 |
| "提取对话中的代码" | 提取代码块 |

## 安装

### 前置依赖

1. **Node.js** >= 20
2. **OpenCLI** — 全局安装：
   ```bash
   npm install -g @jackwener/opencli
   ```
3. **OpenClaw** — 已部署并运行

### 安装技能到 OpenClaw

**方式一：直接复制（推荐）**

```bash
# Linux / macOS
mkdir -p ~/.openclaw/workspace/skills/opencli-natural-commands
cp SKILL.md ~/.openclaw/workspace/skills/opencli-natural-commands/

# Windows (PowerShell)
mkdir -Force "$env:USERPROFILE\.openclaw\workspace\skills\opencli-natural-commands"
Copy-Item SKILL.md "$env:USERPROFILE\.openclaw\workspace\skills\opencli-natural-commands\"
```

**方式二：从 GitHub 克隆**

```bash
cd ~/.openclaw/workspace/skills/
git clone https://github.com/zhangzeyu99-web/opencli-natural-commands.git
```

安装完成后重启 Gateway 加载技能：

```bash
openclaw gateway restart
```

验证：

```bash
openclaw skills list | grep opencli
# 应显示: ✓ ready | 📦 opencli-natural-commands
```

### 配置 B站功能

1. 安装 [OpenCLI Browser Bridge 扩展](https://github.com/jackwener/opencli/releases)（下载 `opencli-extension.zip`，解压后在 `chrome://extensions` 中加载）
2. Chrome 浏览器保持打开并登录 bilibili.com
3. 下载视频需要额外安装 `yt-dlp`：
   ```bash
   pip install yt-dlp
   ```

### 配置 Cursor 控制功能

1. 设置环境变量：
   ```bash
   # Windows PowerShell（永久）
   [Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", "http://127.0.0.1:9226", "User")

   # Linux / macOS
   echo 'export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9226"' >> ~/.bashrc
   ```
2. Cursor 启动时添加调试端口参数：
   ```
   --remote-debugging-port=9226
   ```
   Windows 下可修改 Cursor 桌面快捷方式的「目标」，末尾加上此参数。

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
opencli youtube video "URL或ID"               # 视频元数据
opencli youtube transcript "URL" --lang en    # 获取字幕（指定语言）
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

## 安全说明

- OpenCLI 复用 Chrome 已有登录态，**不存储任何密码**
- 本地 daemon 仅绑定 `127.0.0.1`，外部不可访问
- 代码开源，经过安全审查：[jackwener/opencli](https://github.com/jackwener/opencli)

## 致谢

- [OpenCLI](https://github.com/jackwener/opencli) — 底层 CLI 引擎
- [OpenClaw](https://docs.openclaw.ai/) — AI Agent 平台

## License

MIT
