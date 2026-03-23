# YouTube 视频分析命令参考

## 概述

YouTube 功能分两层：
- **基础层（opencli）**：搜索、元数据、字幕获取 — 通过浏览器 Cookie 调用 YouTube InnerTube API
- **高级层（youtube-clipper 技能联动）**：AI 章节分析、视频剪辑、字幕翻译、双语字幕烧录

## 前置条件

- Chrome 浏览器已打开并登录 youtube.com
- Browser Bridge 扩展已安装
- 高级功能需要 `yt-dlp` 和 `ffmpeg`

## 基础命令

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

## 视频分析工作流

### 快速分析（元数据 + 字幕）

当用户说"分析一下这个YouTube视频"时，执行两步：

```bash
# 步骤1：获取视频基本信息
opencli youtube video "URL" -f json

# 步骤2：获取完整字幕
opencli youtube transcript "URL" -f json
```

然后用 AI 总结：
- 视频主题和核心观点
- 关键时间点和章节
- 重要数据/引用
- 一句话总结

### 深度内容分析

当用户说"详细分析这个视频的内容"时：

1. 获取元数据 → 了解视频背景
2. 获取字幕 → 拿到全部文字内容
3. AI 分析字幕文本，生成：
   - **内容大纲**：按主题划分章节（2-5分钟粒度）
   - **核心要点**：每个章节的关键论述
   - **金句提取**：值得记录的精彩表述
   - **数据/事实**：视频中提到的具体数据
   - **行动建议**：视频给出的可执行建议

### 多视频对比分析

当用户说"对比分析这几个视频"时：

1. 依次获取每个视频的元数据和字幕
2. AI 对比分析：
   - 各自的核心观点
   - 观点的异同
   - 数据/论据对比
   - 综合结论

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
