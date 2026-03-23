---
name: opencli-natural-commands
description: "用自然语言操控 Cursor IDE 和 Bilibili。当用户提到 B站/bilibili/热门/字幕/下载/Cursor控制/Composer/对话导出 等关键词时使用此技能。"
version: 1.0.0
tags: [opencli, cursor, bilibili, natural-language]
---

# OpenCLI 自然语言指令中心

将用户的自然语言翻译为 `opencli` 命令执行。opencli 已全局安装（v1.2.6）。

## 前置条件

- Chrome 浏览器已打开并登录 bilibili.com（B站命令）
- Browser Bridge 扩展已安装（B站命令）
- Cursor 以 `--remote-debugging-port=9226` 启动 + `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9226`（Cursor 命令）

## B站命令

当用户提到 B站、bilibili、热门、排行榜、字幕、UP主、BV号、收藏、历史、下载视频 等关键词时：

```bash
opencli bilibili hot --limit 10              # "B站什么火" / "热门视频"
opencli bilibili search "关键词" --limit 10   # "B站搜XXX" / "找视频"
opencli bilibili me                           # "我的B站信息"
opencli bilibili favorite                     # "我的收藏"
opencli bilibili history --limit 20           # "最近看了什么" / "观看历史"
opencli bilibili feed --limit 10              # "关注动态" / "关注的人发了什么"
opencli bilibili subtitle BVxxx              # "获取字幕" / "拿字幕"
opencli bilibili ranking --limit 10          # "排行榜"
opencli bilibili following --limit 20        # "关注列表" / "关注了谁"
opencli bilibili user-videos UID --limit 10  # "某UP主的视频"
opencli bilibili download BVxxx --output ./  # "下载视频"（需要 yt-dlp）
```

## Cursor 命令

当用户提到控制Cursor、发消息给AI、Composer、对话、导出对话、截图等关键词时：

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

## 输出格式

所有命令支持 `-f` 参数：`table`（默认）/ `json` / `yaml` / `md` / `csv`

## 执行规则

1. 用户没指定 limit 时默认用 10
2. 命令失败时用中文解释原因和解决方案
3. 命令成功后用自然语言总结结果
4. 涉及账号操作先确认
5. 复合操作拆分执行（如"搜然后下载"= 搜索 + 下载）
