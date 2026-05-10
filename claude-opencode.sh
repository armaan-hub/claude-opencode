#!/bin/bash
# Claude Code + OpenCode via free-claude-code proxy - WITHOUT full permissions
# Usage: ~/claude-opencode.sh [model-name]

set -e

# Configuration
PROXY_PORT=8082
PROXY_URL="http://127.0.0.1:$PROXY_PORT"
API_KEY="sk-6Tszrv9jKUGmaE0NzhsuoGJTocujNLvALYzWdzIlbKWaXMRqKKXMunoGVqtTBmCS"
MODEL="${1:-minimax-m2.5-free}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting free-claude-code proxy...${NC}"

# Start free-claude-code proxy in background
cd ~/free-claude-code
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

# Run Claude Code WITHOUT full permissions (will ask for permission when needed)
ANTHROPIC_AUTH_TOKEN="freecc" \
ANTHROPIC_BASE_URL="$PROXY_URL" \
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1 \
claude

kill $PROXY_PID 2>/dev/null || true