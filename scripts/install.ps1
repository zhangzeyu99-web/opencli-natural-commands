# opencli-natural-commands installer for Windows
# Usage: .\scripts\install.ps1

$ErrorActionPreference = "Stop"

$SkillName = "opencli-natural-commands"
$OpenclawDir = "$env:USERPROFILE\.openclaw"
$SkillsDir = "$OpenclawDir\workspace\skills\$SkillName"
$ScriptDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$CursorPort = "9224"

Write-Host "=== $SkillName Installer ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Node.js
try {
    $nodeVer = (node -v) -replace 'v', ''
    $major = [int]($nodeVer.Split('.')[0])
    if ($major -lt 20) {
        Write-Host "[ERROR] Node.js >= 20 required (found v$nodeVer)" -ForegroundColor Red; exit 1
    }
    Write-Host "[OK] Node.js v$nodeVer" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Node.js not found. Install Node.js >= 20 first." -ForegroundColor Red; exit 1
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

# Step 3: Copy entire skill directory (SKILL.md + references/) to OpenClaw
if (-not (Test-Path $OpenclawDir)) {
    Write-Host "[ERROR] OpenClaw not found at $OpenclawDir. Install OpenClaw first." -ForegroundColor Red; exit 1
}

if (Test-Path $SkillsDir) { Remove-Item $SkillsDir -Recurse -Force }
Copy-Item $ScriptDir $SkillsDir -Recurse -Force
# Remove non-skill files from the installed copy
Remove-Item "$SkillsDir\.git" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$SkillsDir\scripts" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$SkillsDir\LICENSE" -Force -ErrorAction SilentlyContinue
Remove-Item "$SkillsDir\README.md" -Force -ErrorAction SilentlyContinue
Remove-Item "$SkillsDir\CHANGELOG.md" -Force -ErrorAction SilentlyContinue
Remove-Item "$SkillsDir\.gitignore" -Force -ErrorAction SilentlyContinue
Write-Host "[OK] Skill + references installed to $SkillsDir" -ForegroundColor Green

# Step 4: Detect Cursor debug port
$actualPort = $null
$listening = netstat -an | Select-String "LISTENING" | Select-String "922"
if ($listening) {
    $match = [regex]::Match($listening.ToString(), '127\.0\.0\.1:(\d+)')
    if ($match.Success) { $actualPort = $match.Groups[1].Value }
}
if (-not $actualPort) { $actualPort = $CursorPort }
Write-Host "[OK] Cursor debug port: $actualPort" -ForegroundColor Green

# Step 5: Set OPENCLI_CDP_ENDPOINT at BOTH User and Machine level
$endpoint = "http://127.0.0.1:$actualPort"
[Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", $endpoint, "User")
try { [Environment]::SetEnvironmentVariable("OPENCLI_CDP_ENDPOINT", $endpoint, "Machine") } catch {}
$env:OPENCLI_CDP_ENDPOINT = $endpoint
Write-Host "[OK] OPENCLI_CDP_ENDPOINT = $endpoint (User + Machine)" -ForegroundColor Green

# Step 6: Update SKILL.md with detected port
$skillFile = "$SkillsDir\SKILL.md"
if (Test-Path $skillFile) {
    (Get-Content $skillFile -Raw) -replace '127\.0\.0\.1:9224', "127.0.0.1:$actualPort" | Set-Content $skillFile -NoNewline
    Write-Host "[OK] SKILL.md updated with port $actualPort" -ForegroundColor Green
}

# Step 7: Update Cursor shortcuts
foreach ($lnkPath in @(
    "$env:USERPROFILE\Desktop\Cursor.lnk",
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Cursor\Cursor.lnk"
)) {
    if (Test-Path $lnkPath) {
        $shell = New-Object -ComObject WScript.Shell
        $lnk = $shell.CreateShortcut($lnkPath)
        if ($lnk.Arguments -notmatch "remote-debugging-port") {
            $lnk.Arguments = ($lnk.Arguments + " --remote-debugging-port=$actualPort").Trim()
            $lnk.Save()
            Write-Host "[OK] Updated shortcut: $lnkPath" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "=== Installation Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Installed files:" -ForegroundColor White
Get-ChildItem $SkillsDir -Recurse -File | ForEach-Object { Write-Host "  $($_.FullName)" }
Write-Host ""
Write-Host "Verify:" -ForegroundColor White
Write-Host "  openclaw skills list | Select-String opencli"
Write-Host ""
Write-Host "Manual step: Install Browser Bridge Chrome extension" -ForegroundColor Yellow
Write-Host "  Download from: https://github.com/jackwener/opencli/releases"
Write-Host "  Unzip -> chrome://extensions -> Developer mode -> Load unpacked"
