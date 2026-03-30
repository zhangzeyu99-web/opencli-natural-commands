# Changelog

## [1.4.0] - 2026-03-23

### Changed
- SKILL.md restructured as thin routing entry (~35 lines). Detailed content lazy-loaded from references/ on demand.
- Each reference file is now self-contained with its own execution rules and technical notes.
- Estimated context reduction: ~70% per invocation (only loads the module actually needed).

## [1.3.0] - 2026-03-23

### Changed
- SKILL.md rewritten in English to reduce token consumption (~40% smaller)
- Added critical batch execution rule: all opencli browser commands must run SEQUENTIALLY to prevent Browser Bridge disconnection
- Chinese preserved only for activation keywords and intent mapping table

## [1.2.0] - 2026-03-23

### Added
- YouTube 主题研究工作流：多视频搜索→批量元数据→字幕获取→AI 综合分析报告
- YouTube 频道浏览：模拟 B站 user-videos 的频道内容浏览能力
- yt-dlp 字幕三级回退策略：opencli → yt-dlp → 仅元数据分析
- 主题研究视频筛选规则：优先高播放、适中时长，跳过 Shorts 和直播回放
- 新自然语言触发词：调研、频道、卖点、评测、对比

### Changed
- SKILL.md description 更新，涵盖 YouTube 和主题研究能力
- 版本号升至 1.2.0

## [1.1.0] - 2026-03-23

### Added
- YouTube 视频分析：search, video, transcript 命令支持
- YouTube 衍生功能：学习笔记生成、内容翻译、会议纪要、多视频对比、内容创作素材
- YouTube-clipper 技能联动：视频剪辑、双语字幕、字幕烧录
- references/youtube-commands.md: YouTube 完整命令参考和分析工作流

## [1.0.0] - 2026-03-23

### Added
- SKILL.md: OpenClaw 技能文件，支持 B站和 Cursor 自然语言指令
- Bilibili 命令支持：hot, search, me, favorite, history, feed, subtitle, dynamic, ranking, following, user-videos, download
- Cursor IDE 命令支持：status, send, ask, read, composer, model, extract-code, history, export, screenshot
- 自然语言意图识别与命令映射
- references/bilibili-commands.md: B站命令完整参考
- references/cursor-commands.md: Cursor 命令完整参考
- references/troubleshooting.md: 常见问题排查指南
- references/security-audit.md: opencli v1.2.6 安全审查报告
- scripts/install.sh: Linux/macOS 一键安装脚本
- scripts/install.ps1: Windows 一键安装脚本（含 Cursor 调试端口自动配置）
