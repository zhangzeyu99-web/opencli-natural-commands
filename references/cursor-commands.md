# Cursor IDE 命令参考

## 概述

Cursor 命令通过 Chrome DevTools Protocol (CDP) 连接 Cursor 的 Electron 内核。需要 Cursor 以调试端口启动。

## 前置配置

### 1. 环境变量

```bash
# Windows PowerShell（永久）
[Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", "http://127.0.0.1:9226", "User")

# Linux / macOS
echo 'export OPENCLI_CDP_ENDPOINT="http://127.0.0.1:9226"' >> ~/.bashrc
source ~/.bashrc
```

### 2. Cursor 启动参数

Cursor 必须带 `--remote-debugging-port=9226` 参数启动：

**Windows**：修改桌面快捷方式的「目标」字段，在 `Cursor.exe"` 后面加上 ` --remote-debugging-port=9226`

**macOS**：
```bash
/Applications/Cursor.app/Contents/MacOS/Cursor --remote-debugging-port=9226
```

**Linux**：
```bash
cursor --remote-debugging-port=9226
```

## 命令详解

### cursor status — 连接状态

```bash
opencli cursor status
```

返回字段：`Status`, `Url`, `Title`

如果显示 `Connected`，说明连接正常。

自然语言触发：
- "Cursor 连上了吗"
- "检查 Cursor 连接"

---

### cursor send — 发送消息

```bash
opencli cursor send "帮我写一个 Python 的快速排序"
```

向 Cursor 的 Chat/Composer 输入框注入文本并提交。不等待回复。

自然语言触发：
- "给 Cursor 发消息 XXX"
- "让 Cursor 帮我 XXX"

---

### cursor ask — 问答（推荐）

```bash
opencli cursor ask "帮我解释一下这段代码的作用"
opencli cursor ask "重构整个模块" --timeout 60
```

发送消息 → 等待 AI 回复 → 返回完整对话。这是最常用的命令。

参数：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `text` (位置参数) | 必填 | 发送的提示词 |
| `--timeout` | 30 | 最长等待秒数 |

返回字段：`Role`, `Text`

自然语言触发：
- "问 Cursor 一个问题"
- "让AI回答 XXX"

---

### cursor read — 读取对话

```bash
opencli cursor read
opencli cursor read -f json
```

提取当前 Chat 面板中的所有消息。

返回字段：`Role` (User/Assistant), `Text`

自然语言触发：
- "看看 Cursor 回复了什么"
- "读一下对话"
- "AI 说了什么"

---

### cursor composer — Composer 模式

```bash
opencli cursor composer "把所有变量名从驼峰改成下划线风格"
```

自动按 `Ctrl+I`（Mac: `Cmd+I`）打开 Composer 面板，注入指令并提交。

自然语言触发：
- "用 Composer 写 XXX"
- "用 Composer 改代码"

---

### cursor model — 当前模型

```bash
opencli cursor model
```

返回当前 Cursor 使用的 AI 模型名称。

自然语言触发：
- "Cursor 用的什么模型"
- "现在是什么 AI"

---

### cursor extract-code — 提取代码

```bash
opencli cursor extract-code
```

从当前对话中提取所有代码块。

自然语言触发：
- "提取对话中的代码"
- "把代码块拿出来"

---

### cursor history — 对话历史

```bash
opencli cursor history
```

列出最近的 Chat/Composer 会话。

自然语言触发：
- "看看之前的对话记录"
- "对话历史"

---

### cursor export — 导出对话

```bash
opencli cursor export
opencli cursor export --output ./my-conversation.md
```

将当前对话导出为 Markdown 文件。

参数：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `--output` | `/tmp/cursor-export.md` | 输出文件路径 |

自然语言触发：
- "导出当前对话"
- "保存对话为文件"
- "把对话保存下来"

---

### cursor screenshot — 截图

```bash
opencli cursor screenshot
```

捕获当前 Cursor 窗口的 DOM 和 Accessibility 快照。

自然语言触发：
- "截个 Cursor 的图"
- "截图"

---

### cursor dump — 调试信息

```bash
opencli cursor dump
```

导出完整的 DOM 和 Accessibility 快照到临时目录，用于调试。

---

### cursor new — 新建标签

```bash
opencli cursor new
```

模拟 `Ctrl+N` 创建新文件/标签。

## 技术原理

Cursor 基于 Electron (VS Code fork)，支持 Chrome DevTools Protocol。opencli 通过 CDP WebSocket 连接 Cursor 进程，使用 `Runtime.evaluate` 在页面上下文中执行 JavaScript 操作 DOM 元素（如 Lexical 编辑器），实现自动化控制。
