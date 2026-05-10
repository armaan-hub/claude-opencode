#!/bin/bash
# Sync all Claude Code sessions to free-claude-code folder
# This ensures /resume shows ALL your conversation history

set -e

TARGET_DIR="$HOME/free-claude-code"
SESSION_DIR="$HOME/.claude/projects"
DEST_DIR="$SESSION_DIR/-Users-armaan-free-claude-code"

echo "Syncing all Claude Code sessions to free-claude-code folder..."

# Create destination if not exists
mkdir -p "$DEST_DIR"

# Find all .jsonl session files in projects folder
SESSION_FILES=$(find "$SESSION_DIR" -name "*.jsonl" -type f 2>/dev/null)

# Copy all session files (skip if already exists and same size)
COUNT=0
for file in $SESSION_FILES; do
    filename=$(basename "$file")
    dest="$DEST_DIR/$filename"

    # Copy if destination doesn't exist or source is newer/larger
    if [ ! -f "$dest" ] || [ "$file" -nt "$dest" ]; then
        cp "$file" "$dest"
        COUNT=$((COUNT + 1))
    fi
done

echo "Synced $COUNT new session files to free-claude-code"
echo "Total sessions now available: $(ls "$DEST_DIR"/*.jsonl 2>/dev/null | wc -l | tr -d ' ')"

# Now run the actual free-claude-code launcher
echo ""
echo "Starting Claude Code with OpenCode AI..."

# Change to target directory
cd "$TARGET_DIR"

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