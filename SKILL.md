---
name: opencli-natural-commands
description: "Natural language control for Bilibili, YouTube, and Cursor IDE via opencli. Route to module-specific references on demand."
version: 1.4.0
tags: [opencli, cursor, bilibili, youtube, natural-language, video-analysis]
---

# OpenCLI Natural Language Skill

Translate user intent into `opencli` commands. This skill uses lazy-loading: read the specific reference file matching user intent instead of loading everything.

## Prerequisites

- `opencli` globally installed (`npm install -g @jackwener/opencli`)
- Chrome + Browser Bridge extension (for Bilibili/YouTube)
- For Cursor: `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9226` + `--remote-debugging-port=9226`

## Routing Table

Match user keywords → read the corresponding reference file → follow its instructions.

| Keywords | Read | Capabilities |
|----------|------|-------------|
| B站, bilibili, 热门, 排行榜, 字幕, UP主, BV号, 收藏, 历史, 动态, 下载视频 | [references/bilibili-commands.md](references/bilibili-commands.md) | 12 commands: hot, search, me, favorite, history, feed, subtitle, dynamic, ranking, following, user-videos, download |
| YouTube, 油管, 视频分析, 转录, 视频总结, 调研, 频道, 卖点, 评测, 对比, podcast | [references/youtube-commands.md](references/youtube-commands.md) | 3 commands + topic research, channel browsing, transcript fallback |
| Cursor, Composer, 对话, 导出, AI模型, 截图 | [references/cursor-commands.md](references/cursor-commands.md) | 10 commands: status, send, ask, read, composer, model, extract-code, history, export, screenshot |

If multiple modules are needed (e.g. "compare B站 and YouTube videos"), read both reference files.

## Global Execution Rules

1. Default `--limit 10` when unspecified
2. **SEQUENTIAL ONLY**: Run opencli browser commands one at a time. Never parallel — Browser Bridge handles single requests. Concurrent calls cause disconnection.
3. On failure: explain in Chinese with fix suggestion
4. On success: summarize in natural language, don't dump raw output
5. Output format: all commands support `-f table|json|yaml|md|csv`
6. Confirm before account-sensitive operations

## Troubleshooting

If commands fail, read [references/troubleshooting.md](references/troubleshooting.md).
