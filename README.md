# RoamNvim

Ghostty handles terminal splits and pane navigation. `Ctrl+H/J/K/L` moves between Neovim windows and Ghostty panes with the same keys on both platforms, replacing what tmux used to do. Shell config is included. Only what gets used is here.

kickstart.nvim base · catppuccin · heirline · bufferline · remote-nvim.nvim

Requires Neovim 0.11+.

## macOS setup

```bash
# 1. Dependencies
brew install neovim git ripgrep fd make go node fzf lazygit
brew install --cask font-jetbrains-mono-nerd-font ghostty
npm install -g @anthropic-ai/claude-code
# For :RemoteStart into .devcontainer projects, also install devpod:
# https://devpod.sh/docs/getting-started/install#install-devpod-cli

# 2. Clone this repo, then run the rest from inside it
git clone <this-repo-url> RoamNvim && cd RoamNvim

# 3. Ghostty config (symlink so repo edits apply live, same as Neovim below)
mkdir -p ~/.config/ghostty
mv ~/.config/ghostty/config ~/.config/ghostty/config.bak 2>/dev/null
ln -s "$(pwd)/ghostty/config" ~/.config/ghostty/config

# 4. Shell config (prepends vi mode + fzf to existing zshrc — must load
#    before anaconda's init block, or conda's early-return can skip it)
{ cat ./shell/zshrc; cat ~/.zshrc 2>/dev/null; } > ~/.zshrc.new && mv ~/.zshrc.new ~/.zshrc && source ~/.zshrc

# 5. Neovim config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
ln -s "$(pwd)" ~/.config/nvim

# 6. Claude Code CLI keybindings (symlink so repo edits apply live). Optional: moves
#    Claude's mode-cycle off Shift-Tab to Ctrl+B. Skip this step if you don't want it.
mkdir -p ~/.claude
mv ~/.claude/keybindings.json ~/.claude/keybindings.json.bak 2>/dev/null
ln -s "$(pwd)/claude/keybindings.json" ~/.claude/keybindings.json

# 7. First launch. Plugins install automatically; quit and reopen for the theme cache.
nvim
```

## Linux setup

```bash
# 1. Dependencies (apt; adjust for your distro)
sudo apt update
sudo apt install -y git ripgrep fd-find make golang-go curl fzf unzip xclip

# Install latest Neovim (this config requires v0.11+)
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim

# Install nvm (Node Version Manager) - don't use apt's nodejs/npm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load nvm immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install Node.js 22
nvm install 22
nvm alias default 22
nvm use 22
node --version

# Install claude-code
npm install -g @anthropic-ai/claude-code

# For :RemoteStart into .devcontainer projects, also install devpod:
# https://devpod.sh/docs/getting-started/install#install-devpod-cli

# Install JetBrainsMono Nerd Font
mkdir -p ~/.local/share/fonts
cd ~/Downloads
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d JetBrainsMono
cp JetBrainsMono/*.ttf ~/.local/share/fonts/
fc-cache -fv
fc-list | grep -i "JetBrains"

# Install Ghostty
sudo add-apt-repository ppa:mkasberg/ghostty-ubuntu -y
sudo apt update && sudo apt install ghostty -y

# 2. Clone this repo, then run the rest from inside it
cd ~
git clone <this-repo-url> RoamNvim && cd RoamNvim

# 3. Ghostty config (symlink so repo edits apply live, same as Neovim below)
mkdir -p ~/.config/ghostty
mv ~/.config/ghostty/config ~/.config/ghostty/config.bak 2>/dev/null
ln -s "$(pwd)/ghostty/config" ~/.config/ghostty/config

# 4. Shell config (prepends vi mode + fzf to existing bashrc — must load
#    before anaconda's init block, or conda's early-return can skip it)
{ cat ./shell/bashrc; cat ~/.bashrc 2>/dev/null; } > ~/.bashrc.new && mv ~/.bashrc.new ~/.bashrc && source ~/.bashrc

# 5. Neovim config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
ln -s "$(pwd)" ~/.config/nvim

# 6. Claude Code CLI keybindings (symlink so repo edits apply live). Optional: moves
#    Claude's mode-cycle off Shift-Tab to Ctrl+B. Skip this step if you don't want it.
mkdir -p ~/.claude
mv ~/.claude/keybindings.json ~/.claude/keybindings.json.bak 2>/dev/null
ln -s "$(pwd)/claude/keybindings.json" ~/.claude/keybindings.json

# 7. First launch. Plugins install automatically; quit and reopen for the theme cache.
nvim
```

## Navigation

Unified across Ghostty panes and Neovim windows. Typical layout: Ghostty horizontal split (Neovim top, terminal bottom) with Neovim vertical splits inside.

| Key | Action |
|---|---|
| `<Space>\` / `<Space>-` | New Neovim split vertical / horizontal |
| `Ctrl+A \` / `Ctrl+A -` | New Ghostty pane vertical / horizontal |
| `Ctrl+Shift+T` | New Ghostty tab (independent pane layout per tab) |
| `<Space>w` / `Ctrl+A x` | Close Neovim window / Ghostty pane |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous Ghostty tab |
| `Ctrl+H/J/K/L` | Navigate between Neovim windows and Ghostty panes |
| `Ctrl+Shift+Arrows` | Resize Ghostty pane (hold to glide) |
| `Ctrl+Shift+H/J/K/L` | Resize Neovim window (hold to glide) |

## Neovim

Leader is `<Space>`. Press `<Space>` to see everything via which-key.

| Key | Action |
|---|---|
| `<Space>e` | Toggle file explorer |
| `<Space>rs/ri/rx/rc/rl` | Remote: start / info / stop / cleanup / log |
| `<Space>ff` / `<Space>fw` | Find files / live grep |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<Space>x` | Close buffer |
| `<Space><Space>` | Find open buffers |
| `<Space>F` | Format buffer |
| `]c` / `[c` | Next / previous git hunk |
| `<Space>gp/gS/gR` | Hunk: preview / stage / reset (gitsigns) |
| `<Space>gd/gc/gh/gH` | Diffview: open / close / file history / repo history |
| `<Space>gL` (visual) | Diffview: history for selected lines |
| `<Space>fr` | Find and replace across codebase (grug-far) |

## Remote / devcontainers

`remote-nvim.nvim` opens the current project inside its `.devcontainer`, so tools run in the container instead of being shimmed from the host. Install `devpod`, open Neovim at the repo root, then run `:RemoteStart`.

| Key | Action |
|---|---|
| `<Space>rs` | Start / attach to a remote session |
| `<Space>ri` | Show remote session info |
| `<Space>rx` | Stop the current remote session |
| `<Space>rc` | Clean up remote workspace / config |
| `<Space>rl` | Open remote-nvim logs |

## Git workflow

**gitsigns: in-buffer hunk navigation and staging.**

| Key | Action |
|---|---|
| `]c` / `[c` | Jump to next / previous hunk |
| `<Space>gp` | Preview hunk diff inline |
| `<Space>gS` | Stage this hunk only |
| `<Space>gR` | Reset (discard) this hunk |

**diffview: review changes and history before committing.**

| Key | Action |
|---|---|
| `<Space>gd` | Diff all changes against HEAD |
| `<Space>gh` | File history (current file) |
| `<Space>gH` | File history (whole repo) |
| `<Space>gL` (visual) | History for selected lines |
| `<Space>gc` | Close diffview |

**lazygit: everything else** (commit, push/pull, branch management, rebase, blame). Run `lazygit` from your Ghostty terminal.

## Ghostty

| Key | Action |
|---|---|
| `Ctrl+Shift+C/V` | Copy / paste |
| `Ctrl+Shift+T/N/W` | New tab / window / close |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tab |
| `Ctrl+A \` / `Ctrl+A -` | New pane vertical / horizontal |
| `Ctrl+A H/J/K/L` | Resize pane |
| `Ctrl+A x` | Close pane |

## Shell (vi mode)

Press `Esc` at the prompt to enter normal mode.

| Key | Action |
|---|---|
| `k` / `j` | History up / down |
| `h` / `l` | Move cursor left / right |
| `w` / `b` | Jump forward / back by word |
| `0` / `$` | Start / end of line |
| `x` | Delete character |
| `v` | Edit command in Neovim, `:wq` to run |
| `i` / `a` | Back to insert mode |
| `Ctrl+R` | Fuzzy search history (fzf) |
| `Ctrl+T` | Fuzzy file picker, inserts path at cursor |
| `history \| fzf` | Search history and pipe result anywhere |

Pipe output to `less` to search through it (replaces Ctrl+U/D scrollback):

```bash
command | less
```

| Key | Action |
|---|---|
| `j` / `k` | Scroll line by line |
| `Ctrl+D` / `Ctrl+U` | Half page down / up |
| `/pattern` | Search forward |
| `n` / `N` | Next / previous match |
| `g` / `G` | Top / bottom |
| `v` | Open in Neovim |
| `q` | Quit back to shell |

## Troubleshooting

**Markdown has no highlighting**: wipe the treesitter cache and reinstall:
```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser/
```
Then `:TSUpdate` inside Neovim.

**Theme not applied**: run `:Lazy reload catppuccin` or restart Neovim.

## AI coding (CLI)

AI work happens in the terminal, not the editor — there's no in-editor AI plugin
(avante.nvim and claudecode.nvim were removed). Run the Claude Code CLI in a Ghostty
pane next to Neovim; `Ctrl+H/J/K/L` moves between the Neovim window and the pane.

The CLI is installed by the setup steps above (`npm install -g @anthropic-ai/claude-code`).
Authenticate once, either way:
- **Subscription:** run `claude` and log in via the browser.
- **API key:** `echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.zshrc && source ~/.zshrc`
  (or `~/.bashrc`).
