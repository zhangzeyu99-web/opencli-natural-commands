---
name: opencli-natural-commands
description: "用自然语言操控 Cursor IDE、Bilibili、HackerNews、微博等 50+ 平台。当用户提到 B站/bilibili/热门/字幕/下载/Cursor控制/Composer/对话导出/爬取网页/HackerNews/微博/V2EX 等关键词时使用此技能。"
version: 2.1.0
tags: [opencli, cursor, bilibili, hackernews, weibo, natural-language, scraping, stealth]
---

# OpenCLI 自然语言指令中心

将用户的自然语言翻译为 `opencli` 命令并执行。

## 前置条件

- `opencli` 已全局安装 (`npm install -g @jackwener/opencli`)
- Chrome 以 `--remote-debugging-port=9222` 启动
- 环境变量 `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9222`
- Browser Bridge 扩展已加载（B站等需浏览器的命令）
- Cursor 命令需额外设置 `OPENCLI_CDP_ENDPOINT=http://127.0.0.1:9226`

**Stealth 反检测**：内置 7 项反检测补丁（navigator.webdriver 隐藏、chrome 对象伪装、plugins 模拟、CDP 痕迹清理等），CDP 连接时自动注入，无需手动配置。

## 意图识别规则

当用户消息包含以下关键词时激活此技能：

**B站**：B站、bilibili、热门、排行榜、弹幕、字幕、UP主、BV号、收藏、历史记录、动态、下载视频
**YouTube**：YouTube、油管、视频分析、转录、字幕翻译、视频笔记、视频总结、剪辑、podcast
**Cursor**：控制Cursor、发给Cursor、Composer、对话历史、导出对话、AI模型、截图
**更多平台**：HackerNews、V2EX、微博、小红书、知乎、微信读书、豆瓣、Reddit

## B站命令

```bash
opencli bilibili hot --limit 10              # "B站什么火" / "热门视频"
opencli bilibili search "关键词" --limit 10   # "B站搜XXX" / "找视频"
opencli bilibili me                           # "我的B站信息"
opencli bilibili favorite                     # "我的收藏"
opencli bilibili history --limit 20           # "最近看了什么" / "观看历史"
opencli bilibili feed --limit 10              # "关注动态" / "关注的人发了什么"
opencli bilibili subtitle BVxxx              # "获取字幕" / "拿字幕"
opencli bilibili dynamic --limit 10          # "B站动态"
opencli bilibili ranking --limit 10          # "排行榜"
opencli bilibili following --limit 20        # "关注列表" / "关注了谁"
opencli bilibili user-videos UID --limit 10  # "某UP主的视频"
opencli bilibili download BVxxx --output ./  # "下载视频"（需要 yt-dlp）
```

## Cursor 命令

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

## YouTube 命令

```bash
opencli youtube search "关键词" --limit 10   # "YouTube搜XXX"
opencli youtube video "URL"                   # "看看这个视频的信息"
opencli youtube transcript "URL"              # "获取字幕" / "视频转文字"
opencli youtube transcript "URL" --lang en    # 指定语言
opencli youtube transcript "URL" --mode raw   # 原始时间戳模式
```

### YouTube 视频分析工作流

当用户说"分析这个YouTube视频"时，组合执行：
1. `youtube video` → 获取元数据（标题、频道、播放量、描述、关键词）
2. `youtube transcript` → 获取完整字幕文本
3. AI 分析生成：内容大纲、核心要点、关键时间点、一句话总结

### 衍生功能

| 用户意图 | 做什么 |
|---------|--------|
| "帮我把视频做成学习笔记" | 元数据+字幕 → AI 生成结构化笔记 |
| "翻译这个英文视频" | 获取英文字幕 → AI 逐段翻译 |
| "整理成会议纪要" | 字幕(含说话人) → AI 生成纪要 |
| "基于视频写篇文章" | 分析内容 → AI 生成文章大纲+素材 |
| "对比分析这几个视频" | 分别获取字幕 → AI 对比观点 |
| "剪辑精华片段" | 联动 youtube-clipper 技能 |

## 更多平台命令

opencli 内置 50+ 平台适配器，以下为常用的：

```bash
# HackerNews（7 命令）
opencli hackernews new --limit 10       # 最新
opencli hackernews best --limit 10      # 最佳
opencli hackernews top --limit 10       # 热门
opencli hackernews search "关键词"      # 搜索

# 微博
opencli weibo hot --limit 10            # 热搜
opencli weibo search "关键词" --limit 10  # 搜索

# V2EX（10+ 命令）
opencli v2ex hot --limit 10             # 热门
opencli v2ex latest --limit 10          # 最新
opencli v2ex node "python" --limit 10   # 节点主题

# 小红书
opencli xiaohongshu search "关键词"     # 搜索
opencli xiaohongshu download "URL"      # 下载笔记

# 微信公众号
opencli weixin download "文章URL"       # 下载公众号文章为 Markdown

# 其他可用：zhihu, weread, douban, reddit, twitter, medium, linkedin...
# 完整列表: opencli --help
```

## 网页内容抓取

当用户需要获取网页正文、爬取数据时，按优先级执行：

| 场景 | 方案 | 说明 |
|------|------|------|
| 公开网页正文 | `web_fetch` 内置工具 | 直接调用，无需命令 |
| 反爬虫/Cloudflare | scrapling | `python -c "from scrapling.fetchers import StealthyFetcher; print(StealthyFetcher.fetch('URL', headless=True).get_text())"` |
| 动态渲染页面 | scrapling DynamicFetcher | `python -c "from scrapling.fetchers import DynamicFetcher; print(DynamicFetcher.fetch('URL', network_idle=True).get_text())"` |
| 以上均失败 | `web_search` 内置工具 | 搜索相关内容兜底 |

## 网页截图

通过 CDP 直接截取当前 Chrome 页面，无需切换到 chrome-browser-automation 技能。

前提：Chrome 以 `--remote-debugging-port=9222` 运行。

```python
python -c "
import json, base64, asyncio, websockets, urllib.request

async def screenshot(output='screenshot.png'):
    tabs = json.loads(urllib.request.urlopen('http://127.0.0.1:9222/json').read())
    page = next(t for t in tabs if t['type'] == 'page')
    async with websockets.connect(page['webSocketDebuggerUrl'], max_size=50*1024*1024) as ws:
        await ws.send(json.dumps({'id':1, 'method':'Page.captureScreenshot', 'params':{'format':'png'}}))
        r = json.loads(await ws.recv())
        with open(output, 'wb') as f:
            f.write(base64.b64decode(r['result']['data']))
    print(f'Saved: {output}')

asyncio.run(screenshot())
"
```

需要 `pip install websockets`。

## 输出格式

所有命令支持 `-f` 参数：`table`（默认）/ `json` / `yaml` / `md` / `csv`

## 执行规则

1. 用户没指定 limit 时默认用 10
2. 命令失败时用中文解释原因和解决方案
3. 命令成功后用自然语言总结结果，不要直接粘贴全部原始输出
4. 涉及账号操作先确认
5. 复合操作拆分执行（如"搜B站XXX然后下载第一个"= 搜索 + 下载两步）
6. 下载操作告知文件保存位置和大小
