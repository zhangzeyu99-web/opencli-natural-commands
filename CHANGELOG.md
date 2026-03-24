# Changelog

## v2.1.0 (2026-03-24)

### New Features
- **Stealth Anti-Detection**: 7 browser stealth patches auto-injected on CDP connect (navigator.webdriver masking, chrome object stub, plugins/languages simulation, CDP trace cleanup)
- **50+ Platform Adapters**: Added HackerNews (7 commands), Weibo search, V2EX expansion (5 new), WeChat article download, Xiaohongshu publish
- **Web Scraping**: Integrated scrapling for anti-Cloudflare and dynamic page rendering
- **CDP Screenshot**: Direct Chrome screenshot via CDP without requiring Gateway

### Changes
- Updated intent recognition rules to include HackerNews, V2EX, Weibo, Xiaohongshu keywords
- Added `OPENCLI_CDP_ENDPOINT` as primary configuration for Chrome connection
- Version bump to align with opencli v1.3.3 feature merge

## v1.0.0 (2026-03-18)

### Initial Release
- B站 (Bilibili) commands: hot, search, subtitle, download, favorites, history
- YouTube commands: search, video info, transcript
- Cursor IDE control: send, ask, read, composer, export
- Natural language intent recognition
- Output format support: table, json, yaml, md, csv
