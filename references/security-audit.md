# 安全审查报告

> 审查对象：jackwener/opencli v1.2.6
> 审查日期：2026-03-23
> 审查范围：daemon、browser bridge、bilibili adapter、cursor adapter

## 审查结论：安全 ✅

## 详细检查项

### 1. 无恶意代码 ✅

所有源码逻辑透明，无混淆代码、无隐藏网络请求、无 eval 注入。

### 2. 凭据安全 ✅

- 不存储任何用户名或密码
- 通过 Chrome 扩展复用浏览器已有的 Cookie/登录态
- Cookie 仅在浏览器上下文内使用（`credentials: 'include'`）
- 下载视频时临时导出 Cookie 为 Netscape 格式给 yt-dlp，用完后 `fs.unlinkSync` 立即删除

### 3. 本地守护进程安全 ✅

daemon（`src/daemon.ts`）防护措施：
- **仅绑定 127.0.0.1**：外网不可访问
- **Origin 检查**：拒绝非 `chrome-extension://` 来源的请求
- **自定义 Header**：要求 `X-OpenCLI` 请求头（浏览器简单请求无法携带）
- **无 CORS 头**：不返回 `Access-Control-Allow-Origin`，阻止跨域
- **请求体大小限制**：1MB 上限，防止 OOM
- **WebSocket verifyClient**：连接前验证 Origin
- **5分钟空闲自动退出**：不常驻

### 4. 用户输入转义 ✅

所有用户输入通过 `JSON.stringify` 转义后注入浏览器上下文，无 XSS 风险。

示例（`src/clis/cursor/send.ts`）：
```javascript
composer.focus();
document.execCommand('insertText', false, text);
// text 通过 JSON.stringify(textToInsert) 传入
```

### 5. 依赖安全 ✅

仅 5 个运行时依赖：

| 包名 | 用途 | 周下载量 |
|------|------|---------|
| chalk | 终端颜色 | 200M+ |
| cli-table3 | 表格输出 | 10M+ |
| commander | CLI 框架 | 100M+ |
| js-yaml | YAML 解析 | 50M+ |
| ws | WebSocket | 80M+ |

全部知名成熟库，无小众高风险依赖。

### 6. 无远程上报 ✅

- 不包含任何分析/遥测代码
- 不向第三方服务器发送数据
- 所有网络请求仅发往目标网站 API（如 `api.bilibili.com`）

### 7. CDP 连接安全 ✅

Cursor 控制使用 CDP（Chrome DevTools Protocol），仅连接本机 `127.0.0.1:9226`，不暴露到外网。

## 注意事项

| 事项 | 风险等级 | 说明 |
|------|---------|------|
| Chrome 需保持打开 | 低 | B站功能依赖，正常使用模式 |
| Cursor 调试端口 | 低 | 仅绑定本机，不暴露外网 |
| yt-dlp 需另装 | 无 | 仅下载功能需要 |
| daemon 端口 19825 | 低 | 仅本机可访问，有多重防护 |
