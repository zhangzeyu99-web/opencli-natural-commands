# YouTube Commands

> **IMPORTANT**: Environment is pre-configured. Execute commands directly via Shell. Do NOT output setup instructions.

## Quick Reference

| User says | Command |
|-----------|---------|
| "YouTube搜XXX" | `opencli youtube search "XXX" --limit 10` |
| "这个视频的信息" | `opencli youtube video "URL_or_ID" -f json` |
| "获取字幕" / "视频转文字" | `opencli youtube transcript "URL_or_ID"` |
| "看看XXX的视频总结卖点" | Topic Research workflow (see below) |
| "这个频道最近发了什么" | Channel Browsing workflow (see below) |
| "分析这个YouTube视频" | Single Video Analysis (video + transcript) |
| "对比这几个视频" | Multi-video compare |

**Note**: Unset `OPENCLI_CDP_ENDPOINT` before running: `Remove-Item env:OPENCLI_CDP_ENDPOINT -ErrorAction SilentlyContinue`

## Commands

### youtube search — 搜索视频

```bash
opencli youtube search "AI agent 2026" --limit 10
opencli youtube search "机器学习教程" --limit 5 -f json
```

参数：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `query` (位置参数) | 必填 | 搜索关键词 |
| `--limit` | 20 | 最大结果数（上限 50） |

返回字段：`rank`, `title`, `channel`, `views`, `duration`, `url`

自然语言触发：
- "在YouTube上搜 XXX"
- "找YouTube视频 XXX"
- "YouTube搜一下 XXX"

---

### youtube video — 视频元数据

```bash
opencli youtube video "https://www.youtube.com/watch?v=xxx"
opencli youtube video xxx -f json
```

返回详细元数据：
| 字段 | 说明 |
|------|------|
| `title` | 视频标题 |
| `channel` | 频道名称 |
| `views` | 播放量 |
| `likes` | 点赞数 |
| `subscribers` | 频道订阅数 |
| `duration` | 时长（秒） |
| `publishDate` | 发布日期 |
| `category` | 分类 |
| `description` | 完整描述 |
| `keywords` | 关键词 |
| `isLive` | 是否直播 |
| `thumbnail` | 封面图 URL |

自然语言触发：
- "看看这个YouTube视频的信息"
- "这个视频什么时候发的、多少播放"
- "分析一下这个YouTube视频"

---

### youtube transcript — 获取字幕/转录

```bash
# 默认：分段合并模式（可读性好）
opencli youtube transcript "https://www.youtube.com/watch?v=xxx"

# 指定语言
opencli youtube transcript xxx --lang zh-Hans
opencli youtube transcript xxx --lang en

# 原始模式（精确时间戳）
opencli youtube transcript xxx --mode raw

# JSON 输出方便进一步处理
opencli youtube transcript xxx -f json
```

参数：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `url` (位置参数) | 必填 | 视频 URL 或 ID |
| `--lang` | 自动选择 | 语言代码（en, zh-Hans, ja 等） |
| `--mode` | `grouped` | `grouped`（段落合并）或 `raw`（逐条） |

**grouped 模式**：自动合并碎片字幕为完整段落，检测说话人切换，插入章节标题
**raw 模式**：保留每条字幕的精确起止时间

自然语言触发：
- "获取这个YouTube视频的字幕"
- "把这个视频的文字稿拿下来"
- "YouTube视频转文字"
- "下载字幕"

---

## 字幕获取三级回退策略

YouTube 字幕接口在某些网络环境下受限。技能使用三级回退确保最大可用性：

### 第一级：opencli 内置（优先）

```bash
opencli youtube transcript "VIDEO_ID" -f json
```

InnerTube Android API 直接获取，速度最快、格式最好（自动分段合并+说话人检测）。

### 第二级：yt-dlp 回退

当 opencli 返回 "No captions available" 时：

```bash
yt-dlp --write-auto-sub --sub-lang en,zh-Hans --skip-download -o "%(id)s" "VIDEO_URL"
```

这会在当前目录生成 `.vtt` 字幕文件。然后读取文件内容供 AI 分析。

yt-dlp 安装：`pip install yt-dlp`

### 第三级：仅元数据分析（兜底）

当字幕完全无法获取时，依赖 `youtube video` 返回的 description 和 keywords 做分析。YouTube 视频的 description 通常包含大量结构化信息（时间戳、要点、链接），keywords 反映核心主题。此时必须明确告知用户"分析仅基于视频描述和关键词，未获取到完整字幕"。

---

## 主题研究工作流（多视频综合分析）

对标 B站的 `search → user-videos → subtitle` 链式操作。这是本技能最强大的 YouTube 功能。

### 真实示例

**用户**："看看 kingshot 的 YouTube 视频总结这个游戏的主要卖点"

**执行过程**：

#### 步骤1：搜索相关视频

```bash
opencli youtube search "kingshot game review" --limit 10 -f json
```

从结果中筛选：
- 优先播放量高的视频（说明内容被认可）
- 优先时长 5-30 分钟的视频（信息密度适中）
- 跳过 Shorts（时长 < 1分钟）和直播回放（时长 > 2小时）
- 选取 3-5 个最相关的视频

#### 步骤2：批量获取元数据

```bash
opencli youtube video "VIDEO_ID_1" -f json
opencli youtube video "VIDEO_ID_2" -f json
opencli youtube video "VIDEO_ID_3" -f json
# ... 对每个筛选出的视频执行
```

重点关注每个视频的：
- `description`：通常包含视频要点、时间戳目录、结论
- `keywords`：反映核心主题标签
- `views` + `likes`：衡量内容质量和受众认可度

#### 步骤3：获取字幕（含回退）

对每个视频依次尝试三级回退策略。即使部分视频无法获取字幕也继续——有元数据就够做基础分析。

#### 步骤4：AI 综合分析

将所有视频的信息汇总，生成结构化报告：

```
## kingshot 游戏主要卖点（基于 N 个 YouTube 视频分析）

### 一句话总结
XXX

### 核心卖点（多视频共识）
1. XXX — 被 N/M 个视频提到
2. XXX — 被 N/M 个视频提到
...

### 差异化观点
- 视频A认为 XXX，但视频B认为 YYY

### 负面评价/顾虑
- XXX

### 推荐观看
- 最全面的评测：[视频标题](URL)
- 最新的内容：[视频标题](URL)

### 数据来源
- 分析基于 X 个视频，其中 Y 个获取了完整字幕，Z 个仅基于描述
```

---

## 频道内容浏览

对标 B站的 `user-videos` 命令。YouTube 没有直接的频道视频 API，用搜索模拟。

### 使用场景

```
用户："看看 Linus Tech Tips 频道最近发了什么"
用户："这个频道都做什么内容"
```

### 执行步骤

```bash
# 步骤1：搜索频道相关视频
opencli youtube search "Linus Tech Tips" --limit 15 -f json

# 步骤2：批量获取元数据
opencli youtube video "VIDEO_ID" -f json   # 对每个结果执行
```

### AI 总结输出

```
## 频道概览：Linus Tech Tips

### 内容方向
- 硬件评测（显卡、CPU、笔记本）
- 科技新闻解读
- 生活科技应用

### 最近热门视频（按播放量）
1. [标题] — XX万播放 — 发布于 XX
2. ...

### 更新频率
约 X 天/条

### 内容风格
轻松幽默 / 深度技术 / ...
```

---

## 单视频深度分析

### 快速分析（元数据 + 字幕）

当用户说"分析一下这个YouTube视频"时：

```bash
# 步骤1：获取视频基本信息
opencli youtube video "URL" -f json

# 步骤2：获取字幕（三级回退）
opencli youtube transcript "URL" -f json
```

AI 总结：视频主题和核心观点、关键时间点、重要数据、一句话总结

### 深度内容分析

当用户说"详细分析这个视频的内容"时：

1. 获取元数据 → 了解视频背景
2. 获取字幕（含回退） → 拿到全部文字内容
3. AI 分析字幕文本，生成：
   - **内容大纲**：按主题划分章节（2-5分钟粒度）
   - **核心要点**：每个章节的关键论述
   - **金句提取**：值得记录的精彩表述
   - **数据/事实**：视频中提到的具体数据
   - **行动建议**：视频给出的可执行建议

### 多视频对比分析

当用户说"对比分析这几个视频"时：

1. 依次获取每个视频的元数据和字幕
2. AI 对比分析：各自的核心观点、观点异同、数据/论据对比、综合结论

---

## 衍生功能

### 学习笔记生成

```
用户："帮我把这个YouTube视频做成学习笔记"
```

执行流程：
1. `youtube video` → 标题、频道、时长
2. `youtube transcript --mode grouped` → 分段字幕
3. AI 生成结构化笔记：
   - 标题 + 元数据
   - 按章节整理要点
   - 关键术语解释
   - 思考问题

### 内容翻译

```
用户："帮我把这个英文YouTube视频翻译成中文"
```

执行流程：
1. `youtube transcript --lang en` → 英文字幕
2. AI 逐段翻译为中文
3. 保持时间轴对应关系

### 播客/会议纪要

```
用户："帮我把这个YouTube播客整理成会议纪要"
```

执行流程：
1. `youtube transcript --mode grouped` → 自动检测说话人
2. AI 生成会议纪要：
   - 参会人/发言人
   - 议题列表
   - 各方观点
   - 结论和行动项

### 内容创作素材

```
用户："我想基于这个视频写一篇公众号文章"
```

执行流程：
1. 获取视频完整内容
2. AI 生成：
   - 文章大纲（适合目标平台）
   - 核心论点提取
   - 引用片段（带时间标记）
   - 推荐标题

---

## 与 youtube-clipper 技能联动

如果 OpenClaw 安装了 `youtube-clipper` 技能，可以做视频剪辑：

```
用户："帮我剪辑这个YouTube视频的精华部分"
```

联动流程：
1. 本技能获取字幕 → 传给 youtube-clipper
2. youtube-clipper 执行：AI 章节分析 → 用户选择片段 → 剪辑 → 双语字幕 → 烧录

触发词："剪辑YouTube"、"提取精华片段"、"做短视频"

---

## 输出格式

所有命令支持 `-f` 参数：

| 格式 | 最佳用途 |
|------|---------|
| `table` | 终端快速查看（默认） |
| `json` | AI Agent 处理、进一步分析 |
| `yaml` | 人类阅读结构化数据 |
| `md` | 笔记导出 |
| `csv` | 表格导入 |

## 技术原理

YouTube 命令使用 InnerTube API（YouTube 的内部 API），通过浏览器登录态获取：
- **搜索**：`/youtubei/v1/search` 端点
- **元数据**：页面内嵌的 `ytInitialPlayerResponse` + `ytInitialData`
- **字幕**：`/youtubei/v1/player` 端点获取字幕 URL（使用 Android 客户端上下文绕过 PoToken）

字幕获取后，`transcript-group.ts` 引擎自动执行：
- 句子边界检测（支持中日韩标点）
- 说话人切换检测（`>>` 标记）
- 章节标题插入
- 碎片合并（2-3秒的片段合并为完整段落）
