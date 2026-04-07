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
| **zsh-syntax-highlighting** | Valid command highlighting | (automatic) |

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

### File Viewing (bat)

```bash
cat <file>              # View with syntax highlighting (bat)
bat --style=numbers      # Add line numbers
bat --language=python    # Force language
bat --paging=never       # Disable pager (stream output)
bat --paging=always      # Always use pager
```

**Pager Navigation (when viewing large files):**

| Key | Action |
|-----|--------|
| `j` / `↓` | Down one line |
| `k` / `↑` | Up one line |
| `Space` / `PgDn` | Down one page |
| `b` / `PgUp` | Up one page |
| `g` | Go to top |
| `G` | Go to bottom |
| `q` | Quit pager |

### Search Tools

**ripgrep (rg) - Fast grep:**

```bash
rg "pattern"                  # Search recursively
rg -i "pattern"               # Case insensitive
rg -g "*.js" "pattern"        # Glob filter
rg -l "pattern"                # List files only
rg -n "pattern"                # Show line numbers
rg -C 3 "pattern"             # Context lines (3 before/after)
rg -v "pattern"                # Invert match (exclude)
```

**fd - Fast find:**

```bash
fd "name"                       # Find files by name
fd -e ext                       # Find by extension
fd -H                           # Include hidden files
fd -d 2                         # Max depth 2
fd -t f                         # Files only
fd -t d                         # Directories only
fd -p "pattern"                 # Search file contents (like grep)
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

### Shell Features

**Command Highlighting (zsh-syntax-highlighting):**
- Valid commands → **green** text
- Invalid commands → **red** text
- Paths/options → color-coded

**Case-Insensitive Autocomplete:**
- Tab completion ignores case
- Matches `ls`, `LS`, `Ls` equally
- Use `Ctrl+Space` for menu selection

---

## Neovim Key Mappings

### Quick Menu (which-key)

Press `<leader>` (Space) and wait ~0.3s to see a popup menu of all available key mappings.

### Vim Essentials

**Movement:**
```
h / j / k / l    Left / down / up / right
w                Next word start
b                Previous word start
e                Next word end
0                Start of line
$                End of line
gg               Go to top of file
G                Go to bottom of file
<number>G        Go to line <number>
```

**Editing:**
```
i                Insert mode (before cursor)
a                Insert mode (after cursor)
I                Insert at start of line
A                Insert at end of line
o                New line below
O                New line above
x                Delete character
dd               Delete line
yy               Yank (copy) line
p                Paste after cursor
P                Paste before cursor
u                Undo
Ctrl+r           Redo
.                Repeat last command
```

### Multi-Select

**Visual Mode:**
```
v                Enter visual mode (character select)
V                Enter visual line mode
Ctrl+v           Enter visual block mode
```

**In Visual Mode:**
```
y                Yank (copy) selection
d                Delete selection
c                Change selection
>                Indent right
<                Indent left
~                Toggle case
```

**Object Selection:**
```
vi"             Select inside quotes
vi)             Select inside parentheses
vi]             Select inside brackets
vap             Select around paragraph
ci"             Change inside quotes
yi"             Yank inside quotes
```

### Visual Multi (Multi-Cursor)

**vim-visual-multi** - Select and edit multiple locations at once.

| Command | Description |
|---------|-------------|
| `\n` | Start multi-select on word under cursor |
| `\N` | Skip to next occurrence |
| `\j` | Select next word |
| `\k` | Select previous word |
| `\s` | Search for pattern to select |
| `\a` | Select all matches |
| `\q` | Remove current selection |
| `\Q` | Remove all selections |
| `\d` | Select next word (Ctrl+D) |
| `\p` | Select previous word |
| `\i` | Insert at start of all selections |
| `\A` | Insert at end of all selections |
| `n` | Select next occurrence |
| `N` | Skip to next occurrence |
| `Esc` | Exit multi-select mode |

**Basic workflow:**
1. Place cursor on a word
2. Press `\n` to select that word
3. Press `n` to jump to next occurrence, `N` to skip
4. Edit once, changes apply to all selections
5. `Esc` to exit multi-select

**Alternative Keybindings (Ctrl+N / Ctrl+Up/Down):**

The default keybindings use `\` (backslash). To use Ctrl+N / Ctrl+Up/Down instead, add these to your `keymaps.lua`:

```lua
-- vim-visual-multi Ctrl keybindings
vim.keymap.set("n", "<C-n>", "<Plug>(VM-select-next)", { silent = true })
vim.keymap.set("n", "<C-j>", "<Plug>(VM-select-next)", { silent = true })  -- Down
vim.keymap.set("n", "<C-k>", "<Plug>(VM-select-previous)", { silent = true })  -- Up
```

| Default | Alternative | Description |
|---------|-------------|-------------|
| `\n` | `Ctrl+n` | Select word under cursor |
| `n` | `Ctrl+j` | Select next occurrence |
| `N` | `Ctrl+k` | Select previous occurrence |

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
