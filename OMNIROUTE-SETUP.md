# Claude Code through OmniRoute (and the OpenCode proxy): setup record

This page records how the two Claude Code launchers were set up so they run side by side with the official `claude` command. No keys are stored here. Replace every `YOUR-...` placeholder with your own value.

## 1. Keep the three Claude setups separate

| Command | Account / gateway | Config folder |
|---|---|---|
| `claude` | Official Anthropic login (Max plan) | `~/.claude` (default) |
| `run-claude-opencode` | Local proxy `free-claude-code` on `127.0.0.1:8082` | `~/.claude-opencode` |
| `run-claude-omniroute` | Local OmniRoute on `127.0.0.1:20128` | `~/.claude-omniroute` |

`CLAUDE_CONFIG_DIR` gives each launcher its own settings, history, rules and plugins. The launchers do not copy sessions into `~/.claude`.

## 2. Install `run-claude-opencode`

1. Copy the script to your PATH:
   ```bash
   mkdir -p ~/.local/bin
   cp claude-opencode.sh ~/.local/bin/run-claude-opencode
   chmod +x ~/.local/bin/run-claude-opencode
   ```
2. Make sure `~/.local/bin` is on PATH (`export PATH="$HOME/.local/bin:$PATH"` in `~/.zshrc`).
3. Give it the key in the environment, never in the file:
   ```bash
   OPENCODE_API_KEY="YOUR-OPENCODE-KEY" run-claude-opencode
   ```
   The script stops with `Set OPENCODE_API_KEY first` if the variable is empty.
4. The script starts the proxy from `~/free-claude-code` (`uv run free-claude-code`), waits for port 8082, then starts Claude Code with:
   - `CLAUDE_CONFIG_DIR=$HOME/.claude-opencode`
   - `ANTHROPIC_BASE_URL=http://127.0.0.1:8082`
   - `ANTHROPIC_AUTH_TOKEN=freecc`
   - `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`
   - `claude --dangerously-skip-permissions`

## 3. Set up OmniRoute

1. Install and start the server (default port 20128):
   ```bash
   omniroute serve
   ```
2. Check the server answers with your key:
   ```bash
   curl -s -o /dev/null -w "%{http_code}\n" -H "Authorization: Bearer $(cat ~/.config/omniroute_key)" http://127.0.0.1:20128/v1/models
   ```
   `200` means the key works.
3. Store the key in a private file (not in the repo, not in `~/.zshrc`):
   ```bash
   umask 077
   printf '%s' "YOUR-OMNIROUTE-KEY" > ~/.config/omniroute_key
   chmod 600 ~/.config/omniroute_key
   ```
4. Add this alias to `~/.zshrc`, then run `source ~/.zshrc`:
   ```bash
   # OmniRoute (local server on 20128) through Claude Code
   alias run-claude-omniroute='unset ANTHROPIC_API_KEY; ANTHROPIC_BASE_URL=http://127.0.0.1:20128 ANTHROPIC_AUTH_TOKEN="$(cat ~/.config/omniroute_key)" CLAUDE_CONFIG_DIR=~/.claude-omniroute claude --dangerously-skip-permissions'
   ```
   The `unset ANTHROPIC_API_KEY` stops a global API key from overriding the OmniRoute token.
5. Start Claude Code through OmniRoute:
   ```bash
   run-claude-omniroute
   run-claude-omniroute --model auto/best-coding
   ```

## 4. Change the model

- At launch: `run-claude-omniroute --model <model-id>`
- Inside a session: `/model`, then pick or type the id.
- Permanent: copy the alias, add `--model <model-id>` at the end, and give it a new name.

Model ids come from OmniRoute's `/v1/models` list (for example `auto/best-coding`, `anthropic/claude-opus-5-5`, `anthropic/claude-sonnet-5-5`, `anthropic/claude-haiku-5-5`). Test each id before relying on it.

## 5. Security checklist (do before pushing or sharing anything)

- Rotate every key that was pasted into chat or saved in a plain file, then overwrite `~/.config/omniroute_key` and the OpenCode key.
- Remove any `export ANTHROPIC_API_KEY=...` line from `~/.zshrc`. A global key makes plain `claude` bill the API instead of the Max plan.
- Bind OmniRoute to localhost: set `OMNIROUTE_SERVER_HOST=127.0.0.1` in `~/.omniroute/.env` and restart. By default it listens on all interfaces and billed providers are reachable from your network.
- Old commits in this repo history still contain a previous OpenCode key. Rotating the key is the fix; rewriting history is separate and needs an explicit decision.

## 6. Status

- Verified: scripts pass `bash -n`; no key in the files; the OmniRoute key returns HTTP 200.
- Not yet verified end-to-end: a full `run-claude-omniroute` session and model routing for each model id; `run-claude-opencode` proxy start and model routing.
