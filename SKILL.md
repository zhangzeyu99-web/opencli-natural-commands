---
name: opencli-natural-commands
description: "用自然语言操控 Cursor IDE、Bilibili 和 YouTube。支持 B站/YouTube 视频搜索、分析、字幕获取、主题研究（多视频综合分析）、频道浏览，以及 Cursor IDE 远程控制。"
version: 1.2.0
tags: [opencli, cursor, bilibili, youtube, natural-language, video-analysis]
---

# OpenCLI 自然语言指令中心

将用户的自然语言翻译为 `opencli` 命令并执行。

## 前置条件

- `opencli` 已全局安装 (`npm install -g @jackwener/opencli`)
- Chrome 浏览器已打开并登录 bilibili.com（B站命令需要）
- Browser Bridge 扩展已安装（B站命令需要）
- Cursor 以 `--remote-debugging-port=9226` 启动 + `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9226`（Cursor 命令需要）

## 意图识别规则

当用户消息包含以下关键词时激活此技能：

**B站**：B站、bilibili、热门、排行榜、弹幕、字幕、UP主、BV号、收藏、历史记录、动态、下载视频
**YouTube**：YouTube、油管、视频分析、转录、字幕翻译、视频笔记、视频总结、剪辑、podcast、调研、频道、卖点、评测、对比
**Cursor**：控制Cursor、发给Cursor、Composer、对话历史、导出对话、AI模型、截图

## B站命令

```bash
opencli bilibili hot --limit 10              # "B站什么火" / "热门视频"
opencli bilibili search "关键词" --limit 10   # "B站搜XXX" / "找视频"
opencli bilibili me                           # "我的B站信息"
opencli bilibili favorite                     # "我的收藏"
opencli bilibili history --limit 20           # "最近看了什么" / "观看历史"
opencli bilibili feed --limit 10              # "关注动态" / "关注的人发了什么"
opencli bilibili subtitle BVxxx              # "获取字幕" / "拿字幕"
opencli bilibili dynamic --limit 10          # "B站动态"
opencli bilibili ranking --limit 10          # "排行榜"
opencli bilibili following --limit 20        # "关注列表" / "关注了谁"
opencli bilibili user-videos UID --limit 10  # "某UP主的视频"
opencli bilibili download BVxxx --output ./  # "下载视频"（需要 yt-dlp）
```

## Cursor 命令

```bash
opencli cursor status                         # "Cursor连上了吗"
opencli cursor send "消息"                     # "发给Cursor" / "让Cursor做XXX"
opencli cursor ask "问题"                      # "问Cursor" / "让AI回答"（等回复）
opencli cursor read                           # "看看AI说了什么" / "读对话"
opencli cursor composer "指令"                 # "用Composer" / "改代码"
opencli cursor model                          # "什么模型" / "用的什么AI"
opencli cursor extract-code                   # "提取代码"
opencli cursor history                        # "对话历史"
opencli cursor export --output ./export.md    # "导出对话" / "保存对话"
opencli cursor screenshot                     # "截个图"
```

## YouTube 命令

当用户提到 YouTube、视频分析、字幕、转录、视频笔记、视频总结 等关键词时：

```bash
opencli youtube search "关键词" --limit 10   # "YouTube搜XXX"
opencli youtube video "URL"                   # "看看这个视频的信息"
opencli youtube transcript "URL"              # "获取字幕" / "视频转文字"
opencli youtube transcript "URL" --lang en    # 指定语言
opencli youtube transcript "URL" --mode raw   # 原始时间戳模式
```

### YouTube 主题研究工作流（核心功能）

当用户说类似"看看 kingshot 的 YouTube 视频总结这个游戏卖点"时，执行多视频综合分析：

**步骤1：搜索相关视频**
```bash
opencli youtube search "kingshot game review" --limit 10 -f json
```

**步骤2：批量获取元数据**（description 和 keywords 信息量极大）
```bash
# 对搜索结果中相关度高的视频逐个执行
opencli youtube video "VIDEO_ID" -f json
```

**步骤3：尝试获取字幕（三级回退）**
```bash
# 优先：opencli 内置
opencli youtube transcript "VIDEO_ID"
# 回退：yt-dlp（内置不可用时）
yt-dlp --write-auto-sub --sub-lang en,zh-Hans --skip-download -o "%(id)s" "URL"
# 兜底：跳过字幕，仅用 description + keywords 分析（告知用户）
```

**步骤4：AI 综合分析**
汇总所有视频的 title/description/keywords/transcript，生成：
- 主题总结（一段话概括）
- 核心卖点/观点（分条列出）
- 多视频共识（大家都提到的）
- 差异观点（有争议的部分）
- 推荐视频（最值得看哪几个）

### YouTube 频道浏览

当用户说"这个频道最近发了什么"或"看看XXX频道的内容"时：
```bash
# 用搜索模拟频道浏览（YouTube 无直接 user-videos 命令）
opencli youtube search "频道名" --limit 15 -f json
# 批量获取元数据
opencli youtube video "VIDEO_ID" -f json   # 对每个结果执行
```
AI 总结：频道主题方向、最热视频、内容风格、更新频率

### 单视频深度分析

当用户说"分析这个YouTube视频"时：
1. `youtube video` → 获取元数据（标题、频道、播放量、描述、关键词）
2. `youtube transcript`（含回退策略）→ 获取字幕文本
3. AI 生成：内容大纲、核心要点、关键时间点、一句话总结

### 自然语言 → 工作流映射

| 用户意图 | 执行的工作流 |
|---------|------------|
| "看看 kingshot YouTube 视频总结游戏卖点" | 主题研究（search → 批量 video → transcript → AI 综合） |
| "帮我调研一下 XXX 话题" | 主题研究 |
| "这个频道最近发了什么" | 频道浏览（search 频道名 → 批量 video → AI 总结） |
| "对比这几个视频的观点" | 多视频 video + transcript → AI 对比 |
| "分析这个YouTube视频" | 单视频深度分析 |
| "帮我把视频做成学习笔记" | 元数据 + 字幕 → AI 结构化笔记 |
| "翻译这个英文视频" | 字幕 → AI 逐段翻译 |
| "整理成会议纪要" | 字幕(含说话人) → AI 纪要 |
| "基于视频写篇文章" | 分析内容 → AI 文章大纲 + 素材 |
| "剪辑精华片段" | 联动 youtube-clipper 技能 |

## 输出格式

所有命令支持 `-f` 参数：`table`（默认）/ `json` / `yaml` / `md` / `csv`

## 执行规则

1. 用户没指定 limit 时默认用 10
2. 命令失败时用中文解释原因和解决方案
3. 命令成功后用自然语言总结结果，不要直接粘贴全部原始输出
4. 涉及账号操作先确认
5. 复合操作拆分执行（如"搜B站XXX然后下载第一个"= 搜索 + 下载两步）
6. 下载操作告知文件保存位置和大小
7. YouTube 字幕三级回退：opencli transcript → yt-dlp --write-auto-sub → 仅用 description/keywords 分析（告知用户数据来源）
8. 主题研究时，从搜索结果中优先选取播放量高、时长适中（5-30分钟）、标题相关度高的视频，跳过 Shorts 和直播回放

## 参考文档

- [B站命令详解](references/bilibili-commands.md)
- [Cursor 命令详解](references/cursor-commands.md)
- [常见问题排查](references/troubleshooting.md)
- [YouTube 视频分析详解](references/youtube-commands.md)
- [安全审查报告](references/security-audit.md)
