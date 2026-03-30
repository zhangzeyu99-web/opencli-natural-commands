#!/usr/bin/env bash
set -euo pipefail

# opencli-natural-commands installer for Linux/macOS
# Usage: bash scripts/install.sh

SKILL_NAME="opencli-natural-commands"
OPENCLAW_DIR="${HOME}/.openclaw"
SKILLS_DIR="${OPENCLAW_DIR}/workspace/skills/${SKILL_NAME}"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CURSOR_PORT="${CURSOR_PORT:-9224}"

echo "=== ${SKILL_NAME} Installer ==="
echo ""

# Step 1: Check Node.js
if ! command -v node &>/dev/null; then
    echo "[ERROR] Node.js not found. Install Node.js >= 20 first."; exit 1
fi
NODE_VER=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VER" -lt 20 ]; then
    echo "[ERROR] Node.js >= 20 required (found v$(node -v))"; exit 1
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

# Step 3: Copy entire skill directory to OpenClaw
if [ ! -d "${OPENCLAW_DIR}" ]; then
    echo "[ERROR] OpenClaw not found at ${OPENCLAW_DIR}. Install OpenClaw first."; exit 1
fi

rm -rf "${SKILLS_DIR}"
mkdir -p "${SKILLS_DIR}"
cp "${SCRIPT_DIR}/SKILL.md" "${SKILLS_DIR}/"
cp -r "${SCRIPT_DIR}/references" "${SKILLS_DIR}/"
echo "[OK] Skill + references installed to ${SKILLS_DIR}"

# Step 4: Detect Cursor debug port
ACTUAL_PORT=$(ss -tlnp 2>/dev/null | grep -oP '127\.0\.0\.1:\K922\d' | head -1 || true)
if [ -z "$ACTUAL_PORT" ]; then ACTUAL_PORT="$CURSOR_PORT"; fi
echo "[OK] Cursor debug port: ${ACTUAL_PORT}"

# Step 5: Set environment variable
ENDPOINT="http://127.0.0.1:${ACTUAL_PORT}"
SHELL_RC="${HOME}/.bashrc"
[ -f "${HOME}/.zshrc" ] && SHELL_RC="${HOME}/.zshrc"

if ! grep -q "OPENCLI_CDP_ENDPOINT" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# opencli Cursor CDP endpoint" >> "$SHELL_RC"
    echo "export OPENCLI_CDP_ENDPOINT=\"${ENDPOINT}\"" >> "$SHELL_RC"
    echo "[OK] Added OPENCLI_CDP_ENDPOINT to ${SHELL_RC}"
else
    echo "[OK] OPENCLI_CDP_ENDPOINT already in ${SHELL_RC}"
fi
export OPENCLI_CDP_ENDPOINT="${ENDPOINT}"

# Step 6: Update SKILL.md with detected port
sed -i "s|127\.0\.0\.1:9224|127.0.0.1:${ACTUAL_PORT}|g" "${SKILLS_DIR}/SKILL.md" 2>/dev/null || true
echo "[OK] SKILL.md updated with port ${ACTUAL_PORT}"

# Step 7: Restart gateway
if command -v openclaw &>/dev/null; then
    echo "[INFO] Restarting OpenClaw gateway..."
    openclaw gateway restart 2>/dev/null || echo "[WARN] Gateway restart failed — restart manually"
fi

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Installed:"
find "${SKILLS_DIR}" -type f | sort
echo ""
echo "Verify: openclaw skills list | grep opencli"
echo ""
echo "Manual steps:"
echo "  1. Install Browser Bridge: https://github.com/jackwener/opencli/releases"
echo "  2. Start Cursor with: --remote-debugging-port=${ACTUAL_PORT}"
echo "  3. Run: source ${SHELL_RC}"
