---
name: opencli-natural-commands
description: "Natural language control for Bilibili, YouTube, and Cursor IDE via opencli. Supports video search, metadata, transcripts, topic research (multi-video analysis), channel browsing, and Cursor remote control."
version: 1.3.0
tags: [opencli, cursor, bilibili, youtube, natural-language, video-analysis]
---

# OpenCLI Natural Language Skill

Translate user intent into `opencli` commands and execute them.

## Prerequisites

- `opencli` installed globally (`npm install -g @jackwener/opencli`)
- Chrome running with Browser Bridge extension (for Bilibili/YouTube)
- Chrome logged into target sites (bilibili.com / youtube.com)
- For Cursor: `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9226` + Cursor launched with `--remote-debugging-port=9226`

## Activation Keywords

**Bilibili**: B站, bilibili, 热门, 排行榜, 字幕, UP主, BV号, 收藏, 历史, 动态, 下载视频
**YouTube**: YouTube, 油管, 视频分析, 转录, 视频总结, 调研, 频道, 卖点, 评测, 对比, podcast
**Cursor**: Cursor, Composer, 对话, 导出, AI模型, 截图

## Bilibili Commands

```bash
opencli bilibili hot --limit 10              # 热门视频
opencli bilibili search "keyword" --limit 10  # 搜索
opencli bilibili me                           # 个人信息
opencli bilibili favorite                     # 收藏夹
opencli bilibili history --limit 20           # 观看历史
opencli bilibili feed --limit 10              # 关注动态
opencli bilibili subtitle BVxxx               # 视频字幕
opencli bilibili dynamic --limit 10           # 动态
opencli bilibili ranking --limit 10           # 排行榜
opencli bilibili following --limit 20         # 关注列表
opencli bilibili user-videos UID --limit 10   # UP主视频
opencli bilibili download BVxxx --output ./   # 下载 (requires yt-dlp)
```

## Cursor Commands

```bash
opencli cursor status                         # connection check
opencli cursor send "message"                 # send to chat
opencli cursor ask "question"                 # send + wait for reply
opencli cursor read                           # read conversation
opencli cursor composer "prompt"              # open Composer (Ctrl+I)
opencli cursor model                          # current AI model
opencli cursor extract-code                   # extract code blocks
opencli cursor history                        # session list
opencli cursor export --output ./export.md    # export as markdown
opencli cursor screenshot                     # capture screenshot
```

## YouTube Commands

```bash
opencli youtube search "keyword" --limit 10   # search videos
opencli youtube video "URL_or_ID"             # video metadata
opencli youtube transcript "URL_or_ID"        # subtitles (grouped mode)
opencli youtube transcript "URL" --lang en    # specify language
opencli youtube transcript "URL" --mode raw   # raw timestamps
```

### Topic Research Workflow (Multi-Video Analysis)

Trigger: user asks to research a topic across multiple videos.
Example: "看看 kingshot 的 YouTube 视频总结游戏卖点"

**Step 1 — Search**
```bash
opencli youtube search "kingshot game review" --limit 10 -f json
```
Filter: prefer high views, 5-30min duration, skip Shorts and livestream replays.

**Step 2 — Batch metadata** (SEQUENTIAL, one at a time)
```bash
opencli youtube video "ID_1" -f json
# wait for completion, then:
opencli youtube video "ID_2" -f json
# ... repeat for each selected video
```

**Step 3 — Transcript with fallback**
```bash
opencli youtube transcript "ID"               # try first
yt-dlp --write-auto-sub --sub-lang en,zh-Hans --skip-download -o "%(id)s" "URL"  # fallback
# last resort: analyze using description + keywords only (inform user)
```

**Step 4 — AI synthesis**
Combine all title/description/keywords/transcript data to produce:
- Topic summary (1 paragraph)
- Key points (bullet list)
- Cross-video consensus
- Divergent opinions
- Recommended videos to watch

### Channel Browsing

Trigger: "这个频道最近发了什么", "看看XXX频道的内容"

```bash
opencli youtube search "channel_name" --limit 15 -f json
# then SEQUENTIALLY get metadata for each result
opencli youtube video "ID" -f json
```
AI output: channel focus, top videos, content style, update frequency.

### Single Video Analysis

Trigger: "分析这个YouTube视频"

1. `youtube video` → metadata (title, channel, views, description, keywords)
2. `youtube transcript` (with fallback) → full text
3. AI generates: outline, key points, timestamps, one-line summary

### Intent → Workflow Mapping

| User says (CN) | Workflow |
|----------------|----------|
| "看看XXX的YouTube视频总结卖点" | Topic Research |
| "帮我调研一下XXX话题" | Topic Research |
| "这个频道最近发了什么" | Channel Browsing |
| "对比这几个视频的观点" | Multi-video compare |
| "分析这个YouTube视频" | Single Video Analysis |
| "帮我把视频做成学习笔记" | metadata + transcript → notes |
| "翻译这个英文视频" | transcript → translate |
| "整理成会议纪要" | transcript (speakers) → minutes |
| "基于视频写篇文章" | content → article outline |
| "剪辑精华片段" | delegate to youtube-clipper skill |

## Output Formats

All commands support `-f`: `table` (default) / `json` / `yaml` / `md` / `csv`

## Execution Rules

1. Default `--limit 10` when user doesn't specify
2. On failure: explain cause and fix in Chinese
3. On success: summarize results in natural language, don't dump raw output
4. Confirm before account-sensitive operations
5. Compound requests: split into sequential steps
6. Report file path and size after downloads
7. **BATCH EXECUTION: Run opencli browser commands SEQUENTIALLY (one at a time). Never run multiple opencli commands in parallel — the Browser Bridge extension handles one request at a time. Concurrent calls cause "Extension not connected" errors.**
8. YouTube transcript 3-tier fallback: opencli → yt-dlp → description-only (tell user the data source)
9. Topic research: prefer high-view, 5-30min videos; skip Shorts and livestream replays

## References

- [Bilibili Commands](references/bilibili-commands.md)
- [Cursor Commands](references/cursor-commands.md)
- [YouTube Analysis](references/youtube-commands.md)
- [Troubleshooting](references/troubleshooting.md)
- [Security Audit](references/security-audit.md)
