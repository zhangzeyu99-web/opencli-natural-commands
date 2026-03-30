---
name: opencli-natural-commands
description: >
  当用户提到以下内容时必须使用此技能（通过Shell执行opencli命令获取实时数据，禁止用训练知识回答）：
  (1) B站/bilibili相关：热门、搜索、字幕、UP主、收藏、历史、动态、排行、下载视频
  (2) YouTube相关：搜索视频、视频分析、字幕转录、频道浏览、主题调研、视频对比
  (3) Cursor IDE相关：查询模型、发送消息、读取对话、Composer、导出对话、截图
  关键词：B站、bilibili、YouTube、油管、Cursor、Composer、模型、热门、字幕、视频
version: 1.6.0
tags: [opencli, cursor, bilibili, youtube, natural-language, video-analysis]
---

# OpenCLI Natural Language Skill

**Execute opencli commands via Shell to get LIVE data. NEVER answer from training knowledge.**

## How It Works (READ THIS FIRST)

opencli has TWO separate communication channels. They are completely independent:

```
Bilibili / YouTube commands
  → opencli daemon (port 19825) → Browser Bridge Chrome extension → Chrome browser
  → Does NOT use Chrome debug port. Does NOT use CDP.
  → Requires: Chrome open + extension enabled + logged into target site

Cursor commands
  → CDP WebSocket → Cursor debug port (e.g. 9224)
  → Does NOT use Browser Bridge or Chrome extension.
  → Requires: OPENCLI_CDP_ENDPOINT env var + Cursor running with --remote-debugging-port
```

**CRITICAL RULES**:
- Do NOT start Chrome with `--remote-debugging-port` for Bilibili/YouTube. They don't need it.
- Do NOT try to restart/kill Chrome. If Browser Bridge is disconnected, just tell the user to open Chrome.
- Bilibili/YouTube and Cursor are independent — one can work while the other fails.

## Command Templates

**Bilibili / YouTube** — must UNSET CDP endpoint (otherwise opencli routes to CDP instead of Browser Bridge):

```powershell
$env:OPENCLI_CDP_ENDPOINT = $null; opencli bilibili hot --limit 10
$env:OPENCLI_CDP_ENDPOINT = $null; opencli bilibili search "关键词" --limit 10
$env:OPENCLI_CDP_ENDPOINT = $null; opencli youtube search "keyword" --limit 10
$env:OPENCLI_CDP_ENDPOINT = $null; opencli youtube video "VIDEO_ID" -f json
$env:OPENCLI_CDP_ENDPOINT = $null; opencli youtube transcript "VIDEO_ID"
```

**Cursor** — must SET CDP endpoint:

```powershell
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9224"; opencli cursor model
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9224"; opencli cursor read
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9224"; opencli cursor ask "question"
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9224"; opencli cursor send "message"
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9224"; opencli cursor composer "prompt"
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9224"; opencli cursor export --output ./export.md
```

**ALWAYS** prefix every command with the env var line. The Shell may not have correct environment.

## Error Handling

| Error | Meaning | Action |
|-------|---------|--------|
| "Extension not connected" | Chrome is closed or extension disabled | Tell user: "请打开Chrome浏览器" — do NOT restart Chrome yourself |
| "connect ECONNREFUSED 127.0.0.1:9222" | OPENCLI_CDP_ENDPOINT is set but shouldn't be | You forgot `$env:OPENCLI_CDP_ENDPOINT = $null` prefix |
| "No inspectable targets" | Cursor not running or no debug port | Tell user: "请用调试端口启动Cursor" |
| "Command timeout" | Slow network or page load | Retry once |

## Routing Table

For detailed parameters and workflows, read the matching reference:

| Keywords | Reference |
|----------|-----------|
| B站, bilibili, 热门, 排行榜, 字幕, UP主, BV号, 收藏, 历史, 动态, 下载视频 | [references/bilibili-commands.md](references/bilibili-commands.md) |
| YouTube, 油管, 视频分析, 转录, 视频总结, 调研, 频道, 卖点, 评测, 对比 | [references/youtube-commands.md](references/youtube-commands.md) |
| Cursor, Composer, 对话, 导出, AI模型, 截图 | [references/cursor-commands.md](references/cursor-commands.md) |

## Execution Rules

1. **ALWAYS run opencli via Shell. NEVER answer from training knowledge.**
2. **ALWAYS prefix with env var** as shown in Command Templates.
3. Run commands **SEQUENTIALLY**, one at a time. Never parallel.
4. Default `--limit 10` when unspecified.
5. On success: summarize in Chinese, don't dump raw output.
6. On failure: check Error Handling table above. If not listed, read [references/troubleshooting.md](references/troubleshooting.md).
