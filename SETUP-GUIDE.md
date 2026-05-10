# Complete Setup Guide: Claude Code + OpenCode AI

This guide walks you through **every single step** to get Claude Code working with OpenCode AI — from zero to running your first AI-powered coding session.

---

## Table of Contents

1. [What is OpenCode AI?](#what-is-opencode-ai)
2. [What You Need](#what-you-need)
3. [Step 1: Install Claude Code](#step-1-install-claude-code)
4. [Step 2: Install uv (Python Package Manager)](#step-2-install-uv)
5. [Step 3: Get OpenCode API Key](#step-3-get-opencode-api-key)
6. [Step 4: Clone This Repository](#step-4-clone-this-repository)
7. [Step 5: Configure Your API Key](#step-5-configure-your-api-key)
8. [Step 6: Run Claude Code](#step-6-run-claude-code)
9. [Choosing a Model](#choosing-a-model)
10. [Troubleshooting](#troubleshooting)

---

## What is OpenCode AI?

OpenCode AI is an AI platform that provides access to **40+ AI models** including:
- Claude (Opus, Sonnet, Haiku)
- Gemini (Google)
- GPT (OpenAI)
- Qwen, MiniMax, and more

**Key benefit:** You can use powerful AI models for coding at a fraction of the cost of using Claude directly through Anthropic.

---

## What You Need

- **Mac or Linux** computer (this guide is for macOS/Linux)
- **Terminal app** (we'll use the built-in Terminal)
- **Internet connection**

That's it! No credit card needed for free tier.

---

## Step 1: Install Claude Code

Claude Code is Anthropic's official CLI tool for coding with AI.

### If you don't have Claude Code installed:

1. Open your Terminal app
2. Run this command:

```bash
brew install anthropic/tap/claude
```

3. Verify installation:
```bash
claude --version
```

You should see something like `claude 2.x.x`

---

## Step 2: Install uv

`uv` is a super-fast Python package manager that free-claude-code needs to run.

### Install uv:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Verify installation:
```bash
uv --version
```

You should see something like `uv 0.x.x`

---

## Step 3: Get OpenCode API Key

### 3.1: Go to OpenCode AI

Open this link in your browser:
```
https://opencode.ai
```

### 3.2: Create Account / Login

1. Click **Sign Up** if you don't have an account
2. Or click **Login** if you already have one

### 3.3: Get Your API Key

1. After logging in, go to your **Workspace Settings**
2. Look for **API Keys** or **Developer** section
3. Click **Create API Key** or **Generate Key**
4. Copy the API key (it starts with `sk-`)

**⚠️ Important:** Copy and save your API key somewhere safe. You won't be able to see it again!

Your API key looks like this:
```
sk-6Tszrv9jKUGmaE0NzhsuoGJTocujNLvALYzWdzIlbKWaXMRqKKXMunoGVqtTBmCS
```

---

## Step 4: Clone This Repository

### 4.1: Open Terminal

Press `Cmd + Space` (Mac), type "Terminal", and press Enter.

### 4.2: Clone the Repository

Run this command:

```bash
git clone https://github.com/armaan-hub/claude-opencode.git
```

### 4.3: Enter the Folder

```bash
cd ~/claude-opencode
```

You can also drag the folder into Terminal after `cd ` to get the path.

### 4.4: Verify Files

```bash
ls -la
```

You should see these files:
```
claude-opencode-full.sh
claude-opencode.sh
providers/opencode/
README.md
```

---

## Step 5: Configure Your API Key

### 5.1: Create .env File

In the `~/claude-opencode` folder, create a file called `.env`:

```bash
echo 'OPENCODE_API_KEY=sk-YOUR-API-KEY-HERE' > .env
echo 'MODEL=opencode/minimax-m2.5-free' >> .env
```

**Important:** Replace `sk-YOUR-API-KEY-HERE` with your actual API key from Step 3!

### 5.2: Verify the .env File

```bash
cat .env
```

It should look like:
```
OPENCODE_API_KEY=sk-6Tszrv9jKUGmaE0NzhsuoGJTocujNLvALYzWdzIlbKWaXMRqKKXMunoGVqtTBmCS
MODEL=opencode/minimax-m2.5-free
```

---

## Step 6: Run Claude Code

### Option A: Full Permissions (Recommended for Development)

This gives Claude Code full access to your files without asking.

```bash
./claude-opencode-full.sh
```

**What it does:**
1. Starts the free-claude-code proxy server
2. Launches Claude Code with `--dangerously-skip-permissions`
3. All your files are accessible

---

### Option B: Safe Mode (Asks for Permissions)

This asks for permission before accessing files.

```bash
./claude-opencode.sh
```

**What it does:**
1. Starts the free-claude-code proxy server
2. Launches Claude Code normally
3. Will ask "Allow this?" when accessing files

---

## Choosing a Model

When running the script, you can specify which AI model to use.

### Syntax:
```bash
./claude-opencode-full.sh model-name
```

### Examples:

```bash
# Default (MiniMax - FREE)
./claude-opencode-full.sh

# MiniMax (Free)
./claude-opencode-full.sh minimax-m2.5-free

# Ring (Free)
./claude-opencode-full.sh ring-2.6-1t-free

# Nemotron (Free)
./claude-opencode-full.sh nemotron-3-super-free

# Qwen (Paid - requires Go plan)
./claude-opencode-full.sh qwen3.6-plus

# Claude Opus (Paid - requires Go plan)
./claude-opencode-full.sh claude-opus-4-7

# Claude Sonnet (Paid - requires Go plan)
./claude-opencode-full.sh claude-sonnet-4-6
```

---

## Available Models

### Free Tier (No Payment Required)
| Model | Description |
|-------|-------------|
| `minimax-m2.5-free` | MiniMax free model - good for general tasks |
| `ring-2.6-1t-free` | Ring 2.6 - good for coding |
| `nemotron-3-super-free` | NVIDIA Nemotron - powerful free option |

### Paid Models (Require OpenCode Go Plan)
| Model | Provider | Best For |
|-------|----------|----------|
| `minimax-m2.7` | MiniMax | Latest MiniMax model |
| `qwen3.6-plus` | Qwen | Very capable, good pricing |
| `qwen3.5-plus` | Qwen | Slightly older Qwen |
| `claude-opus-4-7` | Anthropic | Best for complex tasks |
| `claude-sonnet-4-6` | Anthropic | Great balance of speed/quality |
| `claude-haiku-4-5` | Anthropic | Fast, good for simple tasks |
| `gemini-3.1-pro` | Google | Google's best model |
| `gemini-3-flash` | Google | Fast Google model |
| `gpt-5.5` | OpenAI | Latest GPT |
| `gpt-5.4` | OpenAI | Previous GPT version |

---

## Troubleshooting

### "Command not found: claude"

**Solution:** Claude Code is not installed. Run:
```bash
brew install anthropic/tap/claude
```

### "Command not found: uv"

**Solution:** uv is not installed. Run:
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### "Proxy failed to start"

**Solution:** Port 8082 might be in use. Check what's using it:
```bash
lsof -i :8082
```

Then kill the process or wait a moment and try again.

### "Model not found" or "No payment method"

**This is normal for free tier!**

Free accounts can only use the 3 free models:
- `minimax-m2.5-free`
- `ring-2.6-1t-free`
- `nemotron-3-super-free`

To access paid models, you need to add payment method at:
```
https://opencode.ai/workspace/YOUR-WORKSPACE/billing
```

### "Permission denied" when running scripts

**Solution:** Make scripts executable:
```bash
chmod +x ~/claude-opencode/claude-opencode*.sh
```

### API Key not working

**Solution:** Make sure your `.env` file is correct:
```bash
cat ~/claude-opencode/.env
```

The API key should be exactly as provided by OpenCode (starts with `sk-`).

### Script runs but Claude Code doesn't connect

**Solution:** Check the proxy is running:
1. Look for "Proxy started successfully!" message
2. Make sure you see "Server URL: http://127.0.0.1:8082"

If proxy isn't running, try again with:
```bash
cd ~/claude-opencode
./claude-opencode-full.sh
```

---

## How It Works (Technical Explanation)

If you're curious about what's happening:

```
┌─────────────────────────────────────────────────────────────┐
│  You run: ./claude-opencode-full.sh                         │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  free-claude-code proxy starts on http://127.0.0.1:8082   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Claude Code connects to the proxy instead of Anthropic   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Proxy routes requests to OpenCode AI (opencode.ai/zen)   │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  OpenCode AI processes the request and returns response    │
└─────────────────────────────────────────────────────────────┘
```

---

## Sharing With Friends

To share this with a friend:

1. Give them the repository URL:
   ```
   https://github.com/armaan-hub/claude-opencode
   ```

2. They follow the same steps above

3. They need their own OpenCode API key (free tier works)

---

## Getting Help

If you're stuck:

1. **Check the Troubleshooting section above**
2. **Search for your error message** online
3. **Open an issue** on GitHub:
   ```
   https://github.com/armaan-hub/claude-opencode/issues
   ```

---

## Credits

- **free-claude-code**: https://github.com/Alishahryar1/free-claude-code
- **Claude Code**: https://github.com/anthropics/claude-code
- **OpenCode AI**: https://opencode.ai

This project adds OpenCode AI support to free-claude-code.

---

**Ready? Start with [Step 1: Install Claude Code](#step-1-install-claude-code)**