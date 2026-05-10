# Claude Code + OpenCode AI

**OpenCode-integrated Claude Code** — run Claude Code with OpenCode AI models for free!

This is a modified version of free-claude-code that includes **built-in OpenCode AI support**. No separate proxy setup needed — just add your OpenCode API key and go!

## Features

- Access **40+ models** from OpenCode AI
- Includes Claude Opus, Sonnet, Haiku, Gemini, GPT, Qwen, MiniMax, and more
- **Full permissions** mode or **safe mode** options
- Easy one-command launcher scripts
- Works with OpenCode's Zen API endpoint

## Requirements

- [Claude Code CLI](https://github.com/anthropics/claude-code)
- [uv](https://github.com/astral-sh/uv) (Python package manager)
- OpenCode AI API key (free tier available)

## Installation

### 1. Clone this repository

```bash
git clone https://github.com/armaan-hub/claude-opencode.git
cd claude-opencode
```

### 2. Get OpenCode API Key

1. Go to [opencode.ai](https://opencode.ai)
2. Sign up/Login
3. Get your API key from settings

### 3. Configure API Key

```bash
echo 'OPENCODE_API_KEY=your-api-key-here' > .env
echo 'MODEL=opencode/minimax-m2.5-free' >> .env
```

## Usage

### Option 1: Full Permissions Mode (Recommended for Development)

```bash
./claude-opencode-full.sh
```

This uses `claude --dangerously-skip-permissions` — gives full folder access.

**Model options:**
```bash
./claude-opencode-full.sh          # Default: minimax-m2.5-free
./claude-opencode-full.sh qwen3.6-plus    # Use Qwen
./claude-opencode-full.sh claude-opus-4-7  # Use Claude Opus
./claude-opencode-full.sh ring-2.6-1t-free # Use Ring (free)
```

### Option 2: Safe Mode (Asks for Permissions)

```bash
./claude-opencode.sh
```

This uses plain `claude` — will ask for permission when needed.

## Available Models

| Model | Type | Status |
|-------|------|--------|
| minimax-m2.5-free | MiniMax | FREE |
| minimax-m2.7 | MiniMax | Paid |
| ring-2.6-1t-free | Novita | FREE |
| nemotron-3-super-free | NVIDIA | FREE |
| claude-opus-4-7 | Anthropic | Paid |
| claude-sonnet-4-6 | Anthropic | Paid |
| claude-haiku-4-5 | Anthropic | Paid |
| qwen3.6-plus | Qwen | Paid |
| qwen3.5-plus | Qwen | Paid |
| gemini-3.1-pro | Google | Paid |
| gemini-3-flash | Google | Paid |
| gpt-5.5 | OpenAI | Paid |
| gpt-5.4 | OpenAI | Paid |

**Free tier models:** `minimax-m2.5-free`, `ring-2.6-1t-free`, `nemotron-3-super-free`

## How It Works

1. The launcher script starts a local proxy at `http://127.0.0.1:8082`
2. The proxy routes requests to **OpenCode AI's Zen API** (`opencode.ai/zen/v1`)
3. Claude Code connects to the proxy instead of directly to Anthropic
4. You get access to all OpenCode AI models

## Troubleshooting

### Proxy won't start
```bash
# Make sure port 8082 is free
lsof -i :8082
```

### Model not found
- Free tier only has 3 models
- Other models require OpenCode Go plan (paid)

### Permission denied
- Use `claude-opencode-full.sh` for full permissions
- Or run `claude-opencode.sh` and approve permissions when asked

## Contributing

This project adds OpenCode AI as a provider for free-claude-code.

To contribute the OpenCode provider back to the main project:
1. Fork [free-claude-code](https://github.com/Alishahryar1/free-claude-code)
2. Copy the OpenCode provider files to your fork
3. Submit a pull request

## License

MIT - See [free-claude-code](https://github.com/Alishahryar1/free-claude-code) for original project license.