#!/bin/bash

# System Backup and Recovery Script
# Creates backups of installed packages and system info

set -e

BACKUP_DIR="$HOME/.system-backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/system-backup-$TIMESTAMP"

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

# Create backup directory
mkdir -p "$BACKUP_DIR"

backup_homebrew() {
    log_info "Backing up Homebrew packages..."
    
    if command -v brew &> /dev/null; then
        # Export Brewfile
        brew bundle dump --file="$BACKUP_FILE-Brewfile" --force
        
        # List all installed packages with versions
        brew list --versions > "$BACKUP_FILE-brew-versions.txt"
        
        # List casks with versions
        brew list --cask --versions > "$BACKUP_FILE-cask-versions.txt" 2>/dev/null || true
        
        log_success "Homebrew packages backed up"
    else
        log_warning "Homebrew not found"
    fi
}

backup_npm_packages() {
    log_info "Backing up npm global packages..."
    
    if command -v npm &> /dev/null; then
        npm list -g --depth=0 --json > "$BACKUP_FILE-npm-global.json" 2>/dev/null || true
        npm list -g --depth=0 > "$BACKUP_FILE-npm-global.txt" 2>/dev/null || true
        log_success "npm packages backed up"
    else
        log_warning "npm not found"
    fi
}

backup_pnpm_packages() {
    log_info "Backing up pnpm global packages..."
    
    if command -v pnpm &> /dev/null; then
        pnpm list -g --depth=0 > "$BACKUP_FILE-pnpm-global.txt" 2>/dev/null || true
        log_success "pnpm packages backed up"
    else
        log_warning "pnpm not found"
    fi
}

backup_python_packages() {
    log_info "Backing up Python packages..."
    
    if command -v pip3 &> /dev/null; then
        pip3 freeze > "$BACKUP_FILE-pip-requirements.txt"
        log_success "Python packages backed up"
    else
        log_warning "pip3 not found"
    fi
}

backup_vscode_extensions() {
    log_info "Backing up VS Code extensions..."
    
    if command -v code &> /dev/null; then
        code --list-extensions > "$BACKUP_FILE-vscode-extensions.txt"
        log_success "VS Code extensions backed up"
    else
        log_warning "VS Code not found"
    fi
}

backup_cursor_extensions() {
    log_info "Backing up Cursor extensions..."
    
    if command -v cursor &> /dev/null; then
        cursor --list-extensions > "$BACKUP_FILE-cursor-extensions.txt"
        log_success "Cursor extensions backed up"
    else
        log_warning "Cursor not found"
    fi
}

backup_system_info() {
    log_info "Backing up system information..."
    
    cat > "$BACKUP_FILE-system-info.txt" << EOF
System Backup - $(date)
========================

macOS Version: $(sw_vers -productVersion)
Build: $(sw_vers -buildVersion)
Hostname: $(hostname)
User: $(whoami)
Shell: $SHELL
Architecture: $(uname -m)

Xcode Command Line Tools: $(xcode-select -p 2>/dev/null || echo "Not installed")

Git Version: $(git --version 2>/dev/null || echo "Not installed")
Node Version: $(node --version 2>/dev/null || echo "Not installed")
npm Version: $(npm --version 2>/dev/null || echo "Not installed")
pnpm Version: $(pnpm --version 2>/dev/null || echo "Not installed")
Python Version: $(python3 --version 2>/dev/null || echo "Not installed")
Homebrew Version: $(brew --version 2>/dev/null | head -1 || echo "Not installed")

SSH Keys:
$(ls -la ~/.ssh/ 2>/dev/null | grep -E "\.(pub|key)$" || echo "No SSH keys found")

Development Directories:
$(find ~/code -maxdepth 2 -type d 2>/dev/null | head -20 || echo "No code directory")

EOF
    
    log_success "System information backed up"
}

backup_dotfiles_git_info() {
    log_info "Backing up dotfiles git information..."
    
    if [[ -d "$HOME/dotfiles/.git" ]]; then
        cd "$HOME/dotfiles"
        cat > "$BACKUP_FILE-dotfiles-git.txt" << EOF
Dotfiles Git Information - $(date)
==================================

Current Branch: $(git branch --show-current 2>/dev/null || echo "Unknown")
Remote URL: $(git remote get-url origin 2>/dev/null || echo "No remote")
Last Commit: $(git log -1 --oneline 2>/dev/null || echo "No commits")
Status:
$(git status --porcelain 2>/dev/null || echo "Clean or no git")

Branches:
$(git branch -a 2>/dev/null || echo "No branches")
EOF
        log_success "Dotfiles git info backed up"
    else
        log_warning "Dotfiles directory is not a git repository"
    fi
}

create_restore_script() {
    log_info "Creating restore script..."
    
    cat > "$BACKUP_FILE-restore.sh" << 'EOF'
#!/bin/bash

# System Restore Script
# Generated automatically - customize as needed

set -e

BACKUP_PREFIX="$(dirname "$0")/$(basename "$0" -restore.sh)"

echo "This script will help restore your system from backup."
echo "Backup files prefix: $BACKUP_PREFIX"
echo

# Homebrew
if [[ -f "$BACKUP_PREFIX-Brewfile" ]]; then
    echo "To restore Homebrew packages:"
    echo "  brew bundle --file='$BACKUP_PREFIX-Brewfile'"
    echo
fi

# npm
if [[ -f "$BACKUP_PREFIX-npm-global.txt" ]]; then
    echo "To restore npm global packages, manually install from:"
    echo "  $BACKUP_PREFIX-npm-global.txt"
    echo
fi

# Python
if [[ -f "$BACKUP_PREFIX-pip-requirements.txt" ]]; then
    echo "To restore Python packages:"
    echo "  pip3 install -r '$BACKUP_PREFIX-pip-requirements.txt'"
    echo
fi

# VS Code
if [[ -f "$BACKUP_PREFIX-vscode-extensions.txt" ]]; then
    echo "To restore VS Code extensions:"
    echo "  cat '$BACKUP_PREFIX-vscode-extensions.txt' | xargs -L1 code --install-extension"
    echo
fi

# Cursor
if [[ -f "$BACKUP_PREFIX-cursor-extensions.txt" ]]; then
    echo "To restore Cursor extensions:"
    echo "  cat '$BACKUP_PREFIX-cursor-extensions.txt' | xargs -L1 cursor --install-extension"
    echo
fi

echo "System information is available in:"
echo "  $BACKUP_PREFIX-system-info.txt"
EOF
    
    chmod +x "$BACKUP_FILE-restore.sh"
    log_success "Restore script created"
}

cleanup_old_backups() {
    log_info "Cleaning up old backups (keeping last 5)..."
    
    # Keep only the 5 most recent backups
    ls -t "$BACKUP_DIR"/system-backup-*-system-info.txt 2>/dev/null | tail -n +6 | while read -r file; do
        prefix="${file%-system-info.txt}"
        rm -f "$prefix"*
        log_info "Removed old backup: $(basename "$prefix")"
    done
    
    log_success "Cleanup complete"
}

# Main function
main() {
    log_info "Starting system backup..."
    
    backup_homebrew
    backup_npm_packages
    backup_pnpm_packages
    backup_python_packages
    backup_vscode_extensions
    backup_cursor_extensions
    backup_system_info
    backup_dotfiles_git_info
    create_restore_script
    cleanup_old_backups
    
    echo
    log_success "System backup complete!"
    log_info "Backup saved to: $BACKUP_FILE*"
    log_info "Restore script: $BACKUP_FILE-restore.sh"
    
    # Show backup size
    total_size=$(du -sh "$BACKUP_DIR" | cut -f1)
    log_info "Total backup size: $total_size"
}

# Run main function
main "$@"