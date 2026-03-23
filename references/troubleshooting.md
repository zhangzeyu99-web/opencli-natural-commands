# 常见问题排查

## B站相关

### Q: "Extension not connected"

Chrome 的 OpenCLI Browser Bridge 扩展未安装或未启用。

**解决**：
1. 打开 `chrome://extensions`
2. 确认 "OpenCLI" 扩展存在且已启用
3. 如果没有，从 [Releases](https://github.com/jackwener/opencli/releases) 下载 `opencli-extension.zip`，解压后加载

### Q: 返回空数据 / "Unauthorized"

Chrome 中的 B站登录过期。

**解决**：打开 Chrome → bilibili.com → 手动登录/刷新页面

### Q: 字幕获取失败 / "subtitle_url 为空"

风控拦截或未登录。

**解决**：
1. 确认 Chrome 已登录 B站
2. 尝试在 Chrome 中手动播放该视频
3. 等待几分钟后重试

### Q: 下载视频报 "yt-dlp not installed"

**解决**：`pip install yt-dlp`

### Q: daemon 问题

```bash
opencli doctor                              # 诊断
curl http://localhost:19825/status           # 检查状态
curl http://localhost:19825/logs             # 查看日志
```

daemon 会在第一次运行浏览器命令时自动启动，5分钟空闲后自动退出。

---

## Cursor 相关

### Q: "OPENCLI_CDP_ENDPOINT is not set"

环境变量未设置。

**解决**：
```powershell
# Windows（临时）
$env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9226"

# Windows（永久）
[Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", "http://127.0.0.1:9226", "User")
```

### Q: "No inspectable targets found"

Cursor 没有以调试端口启动。

**解决**：关闭 Cursor，用以下方式重新启动：
- Windows：修改桌面快捷方式目标，末尾加 ` --remote-debugging-port=9226`
- macOS/Linux：`cursor --remote-debugging-port=9226`

### Q: "CDP connect timeout"

Cursor 没有运行，或端口被占用。

**解决**：
1. 确认 Cursor 正在运行
2. 检查端口：`netstat -an | findstr 9226`
3. 如果端口被其他程序占用，换一个端口（同时修改环境变量和启动参数）

### Q: "Could not find Cursor Composer input element"

Cursor 的 UI 结构可能更新了。

**解决**：
1. 确保 Cursor 处于 Chat 或 Composer 面板
2. 尝试先手动点击输入框，再运行命令
3. 更新 opencli 到最新版本：`npm install -g @jackwener/opencli@latest`

---

## 通用问题

### Q: Node.js 版本不够

**解决**：`node --version` 需要 >= 20.0.0。升级 Node.js。

### Q: 命令找不到

**解决**：
```bash
npm install -g @jackwener/opencli    # 重新安装
opencli --version                     # 验证
```

### Q: 其他扩展冲突

某些 Chrome 扩展（youmind、New Tab Override、AI 助手类）可能与 Browser Bridge 冲突。

**解决**：暂时禁用其他扩展后重试。
