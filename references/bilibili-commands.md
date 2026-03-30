# Bilibili (B站) 命令参考

## 概述

所有 B站命令通过 Chrome 浏览器扩展复用登录态，需要 Chrome 保持打开并已登录 bilibili.com。

## 命令详解

### bilibili hot — 热门视频

```bash
opencli bilibili hot --limit 10
opencli bilibili hot -f json      # JSON 输出
```

返回字段：`rank`, `title`, `author`, `play`, `danmaku`

自然语言触发：
- "B站现在什么最火"
- "看看热门视频"
- "B站热门"

---

### bilibili search — 搜索

```bash
opencli bilibili search "黑神话悟空" --limit 10
opencli bilibili search "某UP主" --type user --limit 5
```

参数：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `query` (位置参数) | 必填 | 搜索关键词 |
| `--type` | `video` | `video` 或 `user` |
| `--page` | 1 | 结果页码 |
| `--limit` | 20 | 结果数量 |

返回字段：`rank`, `title`, `author`, `score`, `url`

自然语言触发：
- "帮我在B站搜 AI 视频"
- "B站搜一下 XXX"
- "找XXX的视频"

---

### bilibili me — 我的信息

```bash
opencli bilibili me
```

返回当前登录用户的个人信息。

自然语言触发：
- "我的B站信息"
- "我的B站账号"

---

### bilibili favorite — 收藏夹

```bash
opencli bilibili favorite
```

自然语言触发：
- "我的B站收藏"
- "看看收藏夹"

---

### bilibili history — 观看历史

```bash
opencli bilibili history --limit 20
```

返回字段：`rank`, `title`, `author`, `progress`, `url`

`progress` 显示观看进度，如 `3:45/10:20 (36%)` 或 `已看完`。

自然语言触发：
- "我最近在B站看了什么"
- "观看历史"
- "B站历史记录"

---

### bilibili feed — 关注动态

```bash
opencli bilibili feed --limit 10
```

自然语言触发：
- "关注的人发了什么"
- "B站动态"
- "看看关注动态"

---

### bilibili subtitle — 视频字幕

```bash
opencli bilibili subtitle BV1xx411c7mD
opencli bilibili subtitle BV1xx411c7mD --lang zh-CN
opencli bilibili subtitle BV1xx411c7mD -f json
```

参数：
| 参数 | 说明 |
|------|------|
| `bvid` (位置参数) | 视频 BV 号 |
| `--lang` | 字幕语言代码 (zh-CN, en-US, ai-zh 等) |

返回字段：`index`, `from`, `to`, `content`（按时间轴排列）

自然语言触发：
- "获取这个视频的字幕"
- "把 BVxxx 的字幕拿下来"
- "下载字幕"

> 这是做视频笔记、内容整理的最佳功能。

---

### bilibili dynamic — 动态

```bash
opencli bilibili dynamic --limit 10
```

自然语言触发：
- "B站动态"
- "最新动态"

---

### bilibili ranking — 排行榜

```bash
opencli bilibili ranking --limit 10
```

自然语言触发：
- "B站排行榜"
- "今天什么视频排名高"

---

### bilibili following — 关注列表

```bash
opencli bilibili following --limit 20
opencli bilibili following --uid 12345 --limit 20   # 查看别人的关注
```

自然语言触发：
- "我关注了谁"
- "B站关注列表"

---

### bilibili user-videos — UP主视频

```bash
opencli bilibili user-videos 12345 --limit 10       # 用 UID
opencli bilibili user-videos "某UP主" --limit 10     # 用名字（自动解析 UID）
```

自然语言触发：
- "看看某UP主的视频"
- "XXX 最近发了什么"

---

### bilibili download — 下载视频

```bash
opencli bilibili download BV1xxx --output ./downloads
opencli bilibili download BV1xxx --quality 1080p --output ./videos
opencli bilibili download BV1xxx --quality 720p
```

前置依赖：`pip install yt-dlp`

参数：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `bvid` (位置参数) | 必填 | 视频 BV 号 |
| `--output` | `./bilibili-downloads` | 输出目录 |
| `--quality` | `best` | `best`, `1080p`, `720p`, `480p` |

自然语言触发：
- "下载B站视频 BVxxx"
- "把这个视频下下来"

## 输出格式

所有命令支持 `-f` 参数：

| 格式 | 参数 | 适用场景 |
|------|------|---------|
| 表格 | `-f table` | 终端查看（默认） |
| JSON | `-f json` | 程序处理、AI Agent |
| YAML | `-f yaml` | 人类阅读 |
| Markdown | `-f md` | 文档输出 |
| CSV | `-f csv` | 表格导入 |

## Execution Rules (Bilibili-specific)

1. Run commands SEQUENTIALLY — never parallel. Browser Bridge handles one request at a time.
2. Default `--limit 10` when user doesn't specify.
3. Summarize results in natural Chinese, don't dump raw output.
4. For download: report file path and size after completion.
5. `yt-dlp` required only for `bilibili download`. Other commands work without it.

## Technical Notes

Bilibili commands use `Strategy.COOKIE` — Chrome extension relays browser login cookies to call Bilibili's official API (with WBI signature). No credentials are stored.
