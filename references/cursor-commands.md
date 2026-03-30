# Cursor IDE Commands

> **IMPORTANT**: Environment is pre-configured. Do NOT output setup instructions. Execute commands directly.

## Quick Reference

| User says | Command |
|-----------|---------|
| "Cursor 连上了吗" | `opencli cursor read` (if returns data = connected) |
| "让 Cursor 帮我 XXX" | `opencli cursor send "XXX"` |
| "问 Cursor XXX" / "让AI回答" | `opencli cursor ask "XXX"` |
| "看看 Cursor 回复了什么" | `opencli cursor read` |
| "用 Composer 改代码 XXX" | `opencli cursor composer "XXX"` |
| "Cursor 用的什么模型" | `opencli cursor model` |
| "提取代码" | `opencli cursor extract-code` |
| "对话历史" | `opencli cursor history` |
| "导出对话" / "保存对话" | `opencli cursor export --output ./export.md` |
| "截个图" | `opencli cursor screenshot` |

## Commands

### cursor send — Send message (fire and forget)

```bash
opencli cursor send "帮我写一个 Python 的快速排序"
```

Injects text into Chat/Composer input and submits. Does not wait for reply.

### cursor ask — Send + wait for reply (recommended)

```bash
opencli cursor ask "帮我解释一下这段代码的作用"
opencli cursor ask "重构整个模块" --timeout 60
```

| Param | Default | Description |
|-------|---------|-------------|
| `text` (positional) | required | Prompt text |
| `--timeout` | 30 | Max seconds to wait |

Returns: `Role`, `Text` (User message + Assistant reply)

### cursor read — Read conversation

```bash
opencli cursor read
opencli cursor read -f json
```

Returns all messages in the current Chat panel: `Role` (User/Assistant), `Text`.

### cursor composer — Composer mode (Ctrl+I)

```bash
opencli cursor composer "把所有变量名从驼峰改成下划线风格"
```

Opens Composer panel via keyboard shortcut, injects prompt, submits.

### cursor model — Current AI model

```bash
opencli cursor model
```

### cursor extract-code — Extract code blocks

```bash
opencli cursor extract-code
```

Extracts all multi-line code blocks from the current conversation.

### cursor history — Session list

```bash
opencli cursor history
```

### cursor export — Export conversation

```bash
opencli cursor export
opencli cursor export --output ./my-conversation.md
```

| Param | Default | Description |
|-------|---------|-------------|
| `--output` | `/tmp/cursor-export.md` | Output file path |

### cursor screenshot — Capture screenshot

```bash
opencli cursor screenshot
```

### cursor dump — Debug DOM snapshot

```bash
opencli cursor dump
```

### cursor new — New tab (Ctrl+N)

```bash
opencli cursor new
```

## Execution Rules

1. Cursor commands use CDP (port from `OPENCLI_CDP_ENDPOINT`), NOT Browser Bridge. They work independently of Bilibili/YouTube.
2. `cursor ask` is preferred for most interactions — it sends, waits, and reads in one call.
3. Increase `--timeout` for complex prompts.
4. If connection fails: check that Cursor is running and was launched with `--remote-debugging-port`.

## Setup (only if commands fail)

If Cursor commands return connection errors, the user needs to:

1. Set env var: `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9224`
2. Launch Cursor with: `--remote-debugging-port=9224`
