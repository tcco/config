# tcco/config

My personal dotfiles and system setup for macOS.

## Setup

```bash
# Clone or update
git clone https://github.com/tcco/config ~/config
# or
cd ~/config && git pull

# Run installation
cd ~/config
./install.sh

# Reload shell
source ~/.zshrc
```

### Existing Machine (Migration)

The install script automatically:
- Backs up and migrates `~/.config/gh` and `~/.config/opencode` to the repo
- Symlinks `~/.config` to `~/config/config`
- Replaces `~/.zshrc` with the new zsh config

```bash
cd ~/config
./install.sh
source ~/.zshrc
```

### If You Already Have ~/config

```bash
cd ~/config
git pull  # get latest changes
./install.sh
```

## What's Included

### Terminal Tools

| Tool | Purpose | Key Command |
|------|---------|-------------|
| **Starship** | Fast, minimal prompt | (automatic) |
| **zoxide** | Smarter cd | `j <dir>` |
| **eza** | Modern ls | `ll`, `la`, `lt` |
| **bat** | Cat with syntax highlighting | `cat <file>` |
| **fzf** | Fuzzy finder | `f`, `fh` |
| **delta** | Pretty git diffs | `gdiff` |
| **atuin** | Syncable shell history | (automatic) |
| **ripgrep** | Fast grep | `rg <pattern>` |
| **fd** | Fast find | `fd <pattern>` |
| **tldr** | Simplified man pages | `tldr <command>` |

### Neovim Plugins

| Plugin | Purpose |
|--------|---------|
| **lazy.nvim** | Plugin manager |
| **telescope.nvim** | Fuzzy finding (files, grep, etc.) |
| **nvim-tree** | File tree explorer |
| **nvim-lspconfig** | Language servers |
| **nvim-cmp** | Completion engine |
| **codeium.nvim** | AI code completions |
| **conform.nvim** | Auto-formatting |
| **gitsigns** | Git status in gutter |
| **nvim-treesitter** | Syntax highlighting |
| **Comment.nvim** | Comment toggling |
| **bufferline** | Buffer tabs |
| **lualine** | Status line |
| **trouble** | Diagnostics panel |
| **tokyonight** | Color scheme |

---

## Shell Commands Cheatsheet

### Navigation

```bash
j <dir>       # Jump to directory (zoxide)
..            # Go up one directory
...           # Go up two directories
cd -          # Go to previous directory
```

### File Listing

```bash
ls             # Standard ls
ll             # Long list with details (eza)
la             # List all including hidden (eza)
lt             # Tree view (eza)
```

### Git Shortcuts

```bash
g              # git
gs             # git status
ga             # git add
gaa            # git add --all
gc <msg>       # git commit -m "<msg>"
gca            # git commit -am
gp             # git push
gpl            # git pull
gco <branch>   # git checkout
gcb            # git checkout -b
gb             # git branch
glog           # git log --oneline --graph
gdiff          # git diff | delta
gundo          # git reset --soft HEAD~1
```

### Docker

```bash
dn             # docker network
dc             # docker-compose
```

### Utilities

```bash
ez             # Edit .zshrc
sz             # Source .zshrc
cl             # Clear screen completely
ports          # Show listening ports
ip             # Show external IP
geoip          # GeoIP lookup
findbig        # Find largest files
pycache        # Remove Python cache
```

### Help

```bash
tldr <cmd>     # Quick command reference
man <cmd>      # Full manual
```

---

## Neovim Key Mappings

### General

```
<leader>w      Save
<leader>q      Quit
<leader>Q      Quit all
<leader>sv     Split vertical
<leader>sh     Split horizontal
```

### Navigation

```
C-h/j/k/l      Navigate windows
[b / ]b        Previous/next buffer
<leader>bd     Delete buffer
H / L          Beginning/end of line
j / k          Down/up (display lines)
n / N          Next/prev search (centered)
```

### Telescope (Fuzzy Finding)

```
<leader>ff     Find files
<leader>fg     Live grep
<leader>fb     Find buffers
<leader>fh     Help tags
<leader>fr     Recent files
<leader>/      Search in project
```

### File Tree

```
<leader>e      Toggle file tree
<leader>v      Find file in tree
```

### LSP

```
gd             Go to definition
gD             Go to declaration
gr             Find references
gi             Find implementations
K              Hover documentation
<leader>rn     Rename symbol
<leader>ca     Code actions
<leader>f      Format buffer
```

### Git (Fugitive)

```
<leader>gs     Git status
<leader>gd     Git diff
<leader>gb     Git blame
<leader>gp     Git push
```

### Git Signs

```
]c / [c        Next/prev hunk
<leader>hs     Stage hunk
<leader>hr     Reset hunk
```

### Diagnostics

```
]d / [d        Next/prev diagnostic
<leader>de     Show diagnostic
<leader>xx     Trouble panel
<leader>xw     Workspace diagnostics
gR             LSP references
```

### Comment

```
gcc            Toggle comment (line)
gc             Toggle comment (block)
```

### Quickfix

```
[q / ]q        Previous/next quickfix
```

### Markdown Preview

```
<leader>mp     Open preview
<leader>mc     Close preview
```

### Terminal

```
<leader>tt     Open terminal
<leader>tv     Open terminal (vertical split)
```

---

## Configuration Files

```
.
├── zsh/
│   ├── zshrc          # Main zsh config
│   ├── gitconfig      # Git configuration
│   ├── gitignore      # Global gitignore
│   └── plugins/       # Zsh plugins
├── nvim/
│   ├── init.lua       # Neovim entry point
│   └── lua/config/    # Neovim configuration
│       ├── lazy.lua   # Plugin spec
│       ├── lsp.lua    # LSP servers
│       ├── cmp.lua    # Completion
│       └── keymaps.lua # Keybindings
├── ai/
│   └── skills/
│       └── add-skill/ # Skill for creating skills
├── scripts/
│   ├── link-ai-skills.sh
│   ├── setup-ssh.sh
│   └── setup-vim.sh
├── config/
│   └── starship.toml  # Starship prompt config
├── Brewfile           # Homebrew packages
└── install.sh         # Setup script
```

---

## Customization

### Local Overrides

Create `~/.zshrc.local` for machine-specific settings:

```bash
# ~/.zshrc.local
export EDITOR="code"
alias myalias="echo 'custom'"
```

### Neovim

- Plugin config: `nvim/lua/config/lazy.lua`
- Keymaps: `nvim/lua/config/keymaps.lua`
- LSP: `nvim/lua/config/lsp.lua`

### Starship

- Config: `config/starship.toml`

---

## Troubleshooting

### Neovim plugins not loading

```bash
# Sync plugins
nvim --headless "+Lazy! sync" +qa

# Clear cache and retry
rm -rf ~/.local/share/nvim/lazy-lock.json
nvim +Lazy! sync
```

### Homebrew issues

```bash
# Update brew
brew update && brew upgrade

# Fix permissions
sudo chown -R $(whoami) /usr/local/lib/pkgconfig
```

### Starship prompt slow

```bash
# Check for slow commands in config
starship timing
```

---

## Maintenance

```bash
# Update all Homebrew packages
brew update && brew upgrade

# Update Neovim plugins
nvim +Lazy! update +qa

# Pull latest config
cd ~/config && git pull
```
