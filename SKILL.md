---
name: opencli-natural-commands
description: >
  当用户提到以下内容时必须使用此技能（通过Shell执行opencli命令获取实时数据，禁止用训练知识回答）：
  (1) B站/bilibili相关：热门、搜索、字幕、UP主、收藏、历史、动态、排行、下载视频
  (2) YouTube相关：搜索视频、视频分析、字幕转录、频道浏览、主题调研、视频对比
  (3) Cursor IDE相关：查询模型、发送消息、读取对话、Composer、导出对话、截图
  关键词：B站、bilibili、YouTube、油管、Cursor、Composer、模型、热门、字幕、视频
version: 1.4.2
tags: [opencli, cursor, bilibili, youtube, natural-language, video-analysis]
---

# OpenCLI Natural Language Skill

**This skill executes real commands via Shell to get live data. NEVER answer from training knowledge — always run the opencli command and return actual results.**

## Environment Status

All tools are pre-installed and configured. **Execute commands directly — do NOT guide the user through setup.**

- `opencli` v1.4.0 installed globally
- Chrome Browser Bridge: connected
- Cursor CDP: `OPENCLI_CDP_ENDPOINT` is set, Cursor is running with debug port
- `OPENCLI_CDP_ENDPOINT` must NOT be set when running Bilibili/YouTube commands (unset it first if present in current shell session)

## Routing Table

Match user keywords → read the corresponding reference file → **skip setup sections, go straight to commands and execute them**.

| Keywords | Read | Capabilities |
|----------|------|-------------|
| B站, bilibili, 热门, 排行榜, 字幕, UP主, BV号, 收藏, 历史, 动态, 下载视频 | [references/bilibili-commands.md](references/bilibili-commands.md) | 12 commands: hot, search, me, favorite, history, feed, subtitle, dynamic, ranking, following, user-videos, download |
| YouTube, 油管, 视频分析, 转录, 视频总结, 调研, 频道, 卖点, 评测, 对比, podcast | [references/youtube-commands.md](references/youtube-commands.md) | 3 commands + topic research, channel browsing, transcript fallback |
| Cursor, Composer, 对话, 导出, AI模型, 截图 | [references/cursor-commands.md](references/cursor-commands.md) | 10 commands: status, send, ask, read, composer, model, extract-code, history, export, screenshot |

If multiple modules are needed (e.g. "compare B站 and YouTube videos"), read both reference files.

## Global Execution Rules

1. **ALWAYS execute opencli commands via Shell tool to get real data. NEVER answer from memory/training knowledge.**
2. Default `--limit 10` when unspecified
3. **SEQUENTIAL ONLY**: Run opencli browser commands one at a time. Never parallel.
4. On failure: explain in Chinese with fix suggestion
5. On success: summarize in natural language, don't dump raw output
6. Output format: all commands support `-f table|json|yaml|md|csv`
7. Confirm before account-sensitive operations

## Troubleshooting

If commands fail, read [references/troubleshooting.md](references/troubleshooting.md).
