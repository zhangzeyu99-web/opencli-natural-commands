#!/usr/bin/env bash
set -euo pipefail

# opencli-natural-commands installer for Linux/macOS
# Usage: bash scripts/install.sh

SKILL_NAME="opencli-natural-commands"
OPENCLAW_DIR="${HOME}/.openclaw"
SKILLS_DIR="${OPENCLAW_DIR}/workspace/skills/${SKILL_NAME}"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "=== ${SKILL_NAME} Installer ==="
echo ""

# Step 1: Check Node.js
if ! command -v node &>/dev/null; then
    echo "[ERROR] Node.js not found. Install Node.js >= 20 first."
    exit 1
fi

NODE_VER=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VER" -lt 20 ]; then
    echo "[ERROR] Node.js >= 20 required (found v$(node -v))"
    exit 1
fi
echo "[OK] Node.js $(node -v)"

# Step 2: Install opencli
if command -v opencli &>/dev/null; then
    echo "[OK] opencli $(opencli --version) already installed"
else
    echo "[INSTALLING] opencli..."
    npm install -g @jackwener/opencli
    echo "[OK] opencli $(opencli --version) installed"
fi

# Step 3: Copy skill to OpenClaw
if [ ! -d "${OPENCLAW_DIR}" ]; then
    echo "[ERROR] OpenClaw not found at ${OPENCLAW_DIR}. Install OpenClaw first."
    exit 1
fi

mkdir -p "${SKILLS_DIR}"
cp "${SCRIPT_DIR}/SKILL.md" "${SKILLS_DIR}/SKILL.md"
echo "[OK] Skill installed to ${SKILLS_DIR}"

# Step 4: Restart gateway if running
if command -v openclaw &>/dev/null; then
    echo "[INFO] Restarting OpenClaw gateway to load new skill..."
    openclaw gateway restart 2>/dev/null || echo "[WARN] Gateway restart failed — you may need to restart manually"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Verify: openclaw skills list | grep opencli"
echo ""
echo "Next steps:"
echo "  1. Install Browser Bridge extension for Bilibili"
echo "     Download from: https://github.com/jackwener/opencli/releases"
echo "  2. For Cursor control, set: export OPENCLI_CDP_ENDPOINT=\"http://127.0.0.1:9226\""
echo "     And start Cursor with: --remote-debugging-port=9226"
