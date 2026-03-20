#!/bin/bash

# IDE Settings and Extensions Sync Script
# Syncs extensions and settings for Cursor and VS Code

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Essential extensions for Cursor
EXTENSIONS=(
    "anysphere.cursorpyright"
    "anysphere.remote-ssh"
    "bradlc.vscode-tailwindcss"
    "bungcip.better-toml"
    "catppuccin.catppuccin-vsc-icons"
    "christian-kohler.path-intellisense"
    "dbaeumer.vscode-eslint"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    "formulahendry.auto-rename-tag"
    "github.github-vscode-theme"
    "github.vscode-pull-request-github"
    "golang.go"
    "hbenl.vscode-test-explorer"
    "jdinhlife.gruvbox"
    "knisterpeter.vscode-github"
    "ms-playwright.playwright"
    "ms-python.black-formatter"
    "ms-python.debugpy"
    "ms-python.flake8"
    "ms-python.python"
    "ms-vscode.cmake-tools"
    "ms-vscode.hexeditor"
    "ms-vscode.test-adapter-converter"
    "ms-vscode.vscode-typescript-next"
    "pkief.material-icon-theme"
    "redhat.vscode-yaml"
    "rust-lang.rust-analyzer"
    "tombi-toml.tombi"
)


# Function to install extensions for Cursor
install_cursor_extensions() {
    if ! command -v cursor &> /dev/null; then
        log_warning "Cursor not found, skipping extension installation"
        return
    fi

    log_info "Installing Cursor extensions..."

    # Install shared extensions
    for ext in "${EXTENSIONS[@]}"; do
        if cursor --list-extensions | grep -q "^$ext$"; then
            log_info "$ext already installed in Cursor"
        else
            log_info "Installing $ext in Cursor..."
            if ! cursor --install-extension "$ext" --force 2>/dev/null; then
                log_warning "Failed to install $ext"
                sleep 1  # Brief pause between installations
            fi
        fi
    done


    log_success "Cursor extensions installed"
}

# Function to dump current Cursor extensions for backup
dump_cursor_extensions() {
    if ! command -v cursor &> /dev/null; then
        log_warning "Cursor not found, skipping extension dump"
        return
    fi

    log_info "Dumping current Cursor extensions..."

    # Create backups directory if it doesn't exist
    local backups_dir="$DOTFILES_DIR/.backups"
    mkdir -p "$backups_dir"

    # Create backup of current extensions
    local backup_file="$backups_dir/cursor-extensions-backup-$(date +%Y%m%d-%H%M%S).txt"
    cursor --list-extensions > "$backup_file" 2>/dev/null || {
        log_warning "Failed to dump extensions"
        return
    }

    log_success "Extensions dumped to: $backup_file"

    # Also create a formatted array for easy copy-paste
    local array_file="$backups_dir/cursor-extensions-array-$(date +%Y%m%d-%H%M%S).txt"
    echo "# Copy these to update the EXTENSIONS array in sync-ide-settings.sh" > "$array_file"
    echo "EXTENSIONS=(" >> "$array_file"
    cursor --list-extensions 2>/dev/null | sed 's/^/    "/;s/$/"/' >> "$array_file"
    echo ")" >> "$array_file"

    log_success "Formatted array saved to: $array_file"
}

# Function to sync settings
sync_settings() {
    log_info "Syncing IDE settings..."

    # Create settings directory
    mkdir -p "$HOME/Library/Application Support/Cursor/User"

    # Create Cursor-specific settings file
    cat > "$DOTFILES_DIR/config/cursor-settings.json" << 'EOF'
{
    "editor.fontSize": 14,
    "editor.fontFamily": "MonoLisa, JetBrains Mono, Monaco, 'Courier New', monospace",
    "editor.fontLigatures": true,
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "editor.wordWrap": "bounded",
    "editor.wordWrapColumn": 100,
    "editor.rulers": [80, 100],
    "editor.minimap.enabled": false,
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": "explicit",
        "source.organizeImports": "explicit"
    },
    "files.autoSave": "afterDelay",
    "workbench.colorTheme": "Gruvbox Dark Medium",
    "workbench.iconTheme": "catppuccin-mocha",
    "workbench.startupEditor": "welcomePage",
    "workbench.sideBar.location": "left",
    "workbench.activityBar.visible": true,
    "workbench.activityBar.location": "default",
    "workbench.activityBar.orientation": "vertical",
    "terminal.integrated.fontSize": 13,
    "terminal.integrated.fontFamily": "MonoLisa, JetBrains Mono",
    "terminal.integrated.shell.osx": "/bin/zsh",
    "files.autoSaveDelay": 1000,
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.exclude": {
        "**/.git": true,
        "**/.DS_Store": true,
        "**/node_modules": true,
        "**/.vscode": false
    },
    "search.exclude": {
        "**/node_modules": true,
        "**/bower_components": true,
        "**/.git": true
    },
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "git.autofetch": false,
    "eslint.enable": true,
    "prettier.singleQuote": true,
    "prettier.trailingComma": "es5",
    "prettier.semi": false,
    "typescript.updateImportsOnFileMove.enabled": "always",
    "javascript.updateImportsOnFileMove.enabled": "always",
    "python.defaultInterpreterPath": "/usr/bin/python3",
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": false,
    "python.linting.flake8Enabled": true,
    "python.formatting.provider": "black",
    "security.workspace.trust.enabled": false,
    "telemetry.telemetryLevel": "off"
}
EOF


    # Link settings to Cursor
    if command -v cursor &> /dev/null; then
        ln -sf "$DOTFILES_DIR/config/cursor-settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
        log_success "Cursor settings synced"
    else
        log_warning "Cursor not found, skipping settings sync"
    fi
}

# Function to create keybindings
create_keybindings() {
    log_info "Creating keybindings..."

    cat > "$DOTFILES_DIR/config/ide-keybindings.json" << 'EOF'
[
    {
        "key": "cmd+shift+e",
        "command": "workbench.view.explorer"
    },
    {
        "key": "cmd+shift+f",
        "command": "workbench.view.search"
    },
    {
        "key": "cmd+shift+g",
        "command": "workbench.view.scm"
    },
    {
        "key": "cmd+shift+d",
        "command": "workbench.view.debug"
    },
    {
        "key": "cmd+shift+x",
        "command": "workbench.view.extensions"
    },
    {
        "key": "cmd+shift+u",
        "command": "workbench.view.output"
    },
    {
        "key": "cmd+shift+y",
        "command": "workbench.debug.action.toggleRepl"
    },
    {
        "key": "cmd+shift+m",
        "command": "workbench.actions.view.problems"
    },
    {
        "key": "cmd+j",
        "command": "workbench.action.togglePanel"
    },
    {
        "key": "cmd+shift+c",
        "command": "workbench.action.terminal.new"
    }
]
EOF

    # Link keybindings to Cursor
    if command -v cursor &> /dev/null; then
        ln -sf "$DOTFILES_DIR/config/ide-keybindings.json" "$HOME/Library/Application Support/Cursor/User/keybindings.json"
        log_success "Cursor keybindings synced"
    else
        log_warning "Cursor not found, skipping keybindings sync"
    fi
}

# Main function
main() {
    log_info "Starting Cursor settings sync..."

    # Create config directory
    mkdir -p "$DOTFILES_DIR/config"

    # Handle command line arguments
    if [[ "$1" == "--dump" ]]; then
        dump_cursor_extensions
        return
    fi

    # Install extensions
    install_cursor_extensions

    # Sync settings and keybindings
    sync_settings
    create_keybindings

    log_success "Cursor settings sync complete!"
    log_info "Restart Cursor to apply all changes"
    log_info "To backup current extensions, run: $0 --dump"
}

# Run main function
main "$@"
