# opencli-natural-commands installer for Windows
# Usage: .\scripts\install.ps1

$ErrorActionPreference = "Stop"

$SkillName = "opencli-natural-commands"
$OpenclawDir = "$env:USERPROFILE\.openclaw"
$SkillsDir = "$OpenclawDir\workspace\skills\$SkillName"
$ScriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

Write-Host "=== $SkillName Installer ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Node.js
try {
    $nodeVer = (node -v) -replace 'v', ''
    $major = [int]($nodeVer.Split('.')[0])
    if ($major -lt 20) {
        Write-Host "[ERROR] Node.js >= 20 required (found v$nodeVer)" -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] Node.js v$nodeVer" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js not found. Install Node.js >= 20 first." -ForegroundColor Red
    exit 1
}

# Step 2: Install opencli
try {
    $ver = opencli --version 2>$null
    Write-Host "[OK] opencli v$ver already installed" -ForegroundColor Green
} catch {
    Write-Host "[INSTALLING] opencli..." -ForegroundColor Yellow
    npm install -g @jackwener/opencli
    $ver = opencli --version
    Write-Host "[OK] opencli v$ver installed" -ForegroundColor Green
}

# Step 3: Copy skill to OpenClaw
if (-not (Test-Path $OpenclawDir)) {
    Write-Host "[ERROR] OpenClaw not found at $OpenclawDir. Install OpenClaw first." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
Copy-Item "$ScriptDir\SKILL.md" "$SkillsDir\SKILL.md" -Force
Write-Host "[OK] Skill installed to $SkillsDir" -ForegroundColor Green

# Step 4: Set up Cursor debug port
$currentVal = [Environment]::GetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", "User")
if (-not $currentVal) {
    [Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", "http://127.0.0.1:9226", "User")
    $env:OPENCLI_CDP_ENDPOINT = "http://127.0.0.1:9226"
    Write-Host "[OK] OPENCLI_CDP_ENDPOINT set permanently" -ForegroundColor Green
} else {
    Write-Host "[OK] OPENCLI_CDP_ENDPOINT already set: $currentVal" -ForegroundColor Green
}

# Step 5: Update Cursor shortcut
$desktopLnk = "$env:USERPROFILE\Desktop\Cursor.lnk"
if (Test-Path $desktopLnk) {
    $shell = New-Object -ComObject WScript.Shell
    $lnk = $shell.CreateShortcut($desktopLnk)
    if ($lnk.Arguments -notmatch "remote-debugging-port") {
        $lnk.Arguments = ($lnk.Arguments + " --remote-debugging-port=9226").Trim()
        $lnk.Save()
        Write-Host "[OK] Cursor shortcut updated with debug port" -ForegroundColor Green
    } else {
        Write-Host "[OK] Cursor shortcut already has debug port" -ForegroundColor Green
    }
}

# Step 6: Restart gateway
try {
    Write-Host "[INFO] Restarting OpenClaw gateway..." -ForegroundColor Yellow
    openclaw gateway restart 2>$null
    Write-Host "[OK] Gateway restarted" -ForegroundColor Green
} catch {
    Write-Host "[WARN] Gateway restart failed - restart manually" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Verify: openclaw skills list | Select-String opencli"
Write-Host ""
Write-Host "Remaining manual step:" -ForegroundColor Yellow
Write-Host "  Install Browser Bridge extension for Bilibili commands:"
Write-Host "  Download from: https://github.com/jackwener/opencli/releases"
Write-Host "  Unzip, then load in chrome://extensions (Developer mode)"
