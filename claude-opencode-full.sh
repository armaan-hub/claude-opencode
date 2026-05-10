#!/bin/bash
# Claude Code + OpenCode via free-claude-code proxy - WITH FULL PERMISSIONS
# Usage:
#   ~/claude-opencode-full.sh                     # Free tier: minimax-m2.5-free
#   OPENCODE_API_KEY="sk-..." ~/claude-opencode-full.sh           # Go plan with default model
#   OPENCODE_API_KEY="sk-..." ~/claude-opencode-full.sh qwen3.6-plus  # Go plan with specific model
#   ~/claude-opencode-full.sh claude-opus-4-7                      # Go plan model (requires API key)
#
# Model options (all available via Go plan):
#   Free: minimax-m2.5-free, ring-2.6-1t-free, nemotron-3-super-free
#   Paid: claude-opus-4-7, claude-sonnet-4-6, claude-haiku-4-5, qwen3.6-plus,
#         qwen3.5-plus, gemini-3.1-pro, gemini-3-flash, gpt-5.5, gpt-5.4, etc.

set -e

# Configuration - use env var if set, otherwise Go plan API key (all 40+ models)
PROXY_PORT=8082
PROXY_URL="http://127.0.0.1:$PROXY_PORT"
API_KEY="${OPENCODE_API_KEY:-sk-6Tszrv9jKUGmaE0NzhsuoGJTocujNLvALYzWdzIlbKWaXMRqKKXMunoGVqtTBmCS}"
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

# Wait for proxy to be ready AND model list to be populated
echo "Waiting for proxy to start..."
MODEL_COUNT=0
for i in {1..30}; do
    if curl -s "$PROXY_URL" > /dev/null 2>&1; then
        # Check if model list has loaded
        MODEL_COUNT=$(curl -s "$PROXY_URL/v1/models" -H "x-api-key: freecc" 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(len(d.get('data',[])))" 2>/dev/null || echo "0")
        if [ "$MODEL_COUNT" -gt 10 ]; then
            echo -e "${GREEN}Proxy started with $MODEL_COUNT models!${NC}"
            break
        fi
        echo "  Loading models... ($MODEL_COUNT so far)"
    fi
    if ! kill -0 $PROXY_PID 2>/dev/null; then
        echo -e "${RED}Proxy failed!${NC}"
        cat /tmp/free-claude-code.log
        exit 1
    fi
    sleep 1
done

if [ "$MODEL_COUNT" -le 10 ]; then
    echo -e "${YELLOW}Warning: Only $MODEL_COUNT models loaded (may be still loading)${NC}"
fi

echo -e "${GREEN}Proxy URL: $PROXY_URL${NC}"
echo -e "${GREEN}Model: $MODEL${NC}"
echo ""

# Run Claude Code WITH full permissions (--dangerously-skip-permissions)
echo -e "${YELLOW}Starting Claude Code with full permissions...${NC}"
ANTHROPIC_AUTH_TOKEN="freecc" \
ANTHROPIC_BASE_URL="$PROXY_URL" \
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1 \
claude --dangerously-skip-permissions

kill $PROXY_PID 2>/dev/null || true