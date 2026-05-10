#!/bin/bash
# Claude Code + OpenCode via free-claude-code proxy - SAFE MODE (asks for permissions)
# Usage:
#   ./claude-opencode.sh                        # Free tier: minimax-m2.5-free
#   OPENCODE_API_KEY="sk-..." ./claude-opencode.sh qwen3.6-plus  # Go plan model

set -e

# Session sync
SESSION_DIR="$HOME/.claude/projects"
DEST_DIR="$SESSION_DIR/-Users-armaan-free-claude-code"
mkdir -p "$DEST_DIR"
for file in $(find "$SESSION_DIR" -name "*.jsonl" -type f 2>/dev/null); do
    dest="$DEST_DIR/$(basename "$file")"
    [ ! -f "$dest" ] || [ "$file" -nt "$dest" ] && cp "$file" "$dest"
done

cd ~/free-claude-code

# Configuration
PROXY_PORT=8082
PROXY_URL="http://127.0.0.1:$PROXY_PORT"
API_KEY="${OPENCODE_API_KEY:-sk-GrYsoSdvuAdQ27saHPsUA3NH25VgvbVJYST3JhB4l3ZemldbPQv591mHWEnxxRjv}"
MODEL="${1:-minimax-m2.5-free}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting free-claude-code proxy...${NC}"

# Start free-claude-code proxy in background
export OPENCODE_API_KEY="$API_KEY"
export MODEL="opencode/$MODEL"
uv run free-claude-code > /tmp/free-claude-code.log 2>&1 &
PROXY_PID=$!

# Wait for proxy to be ready
echo "Waiting for proxy to start..."
for i in {1..30}; do
    if curl -s "$PROXY_URL" > /dev/null 2>&1; then
        echo -e "${GREEN}Proxy started!${NC}"
        break
    fi
    if ! kill -0 $PROXY_PID 2>/dev/null; then
        echo -e "${RED}Proxy failed!${NC}"
        cat /tmp/free-claude-code.log
        exit 1
    fi
    sleep 1
done

echo -e "${GREEN}Proxy URL: $PROXY_URL${NC}"
echo -e "${GREEN}Model: $MODEL${NC}"
echo ""

# Run Claude Code WITH full permissions
echo -e "${YELLOW}Starting Claude Code with full permissions...${NC}"
ANTHROPIC_AUTH_TOKEN="freecc" \
ANTHROPIC_BASE_URL="$PROXY_URL" \
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1 \
claude --dangerously-skip-permissions

# Cleanup on exit
kill $PROXY_PID 2>/dev/null || true