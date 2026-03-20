#!/bin/bash

# tcco/config Installation Script
# Simple setup for new and existing machines

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_step() { echo -e "${PURPLE}[STEP]${NC} $1"; }

backup_if_exists() {
    local file="$1"
    if [[ -e "$file" && ! -L "$file" ]]; then
        log_warning "Backing up existing $file"
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/"
    fi
}

link_file() {
    local src="$1"
    local dest="$2"
    if [[ ! -f "$src" ]]; then
        log_error "Source file $src not found"
        return 1
    fi
    backup_if_exists "$dest"
    mkdir -p "$(dirname "$dest")"
    rm -f "$dest"
    ln -sf "$src" "$dest"
    log_success "Linked $src -> $dest"
}

link_directory() {
    local src="$1"
    local dest="$2"
    if [[ ! -d "$src" ]]; then
        log_error "Source directory $src not found"
        return 1
    fi
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        log_warning "Backing up $dest"
        mkdir -p "$BACKUP_DIR"
        cp -r "$dest" "$BACKUP_DIR/"
    fi
    rm -rf "$dest"
    ln -sf "$src" "$dest"
    log_success "Linked $src -> $dest"
}

main() {
    echo ""
    echo "============================================"
    echo "  tcco/config Installation"
    echo "============================================"
    echo ""

    # ==========================================================================
    # Check Xcode
    # ==========================================================================
    log_step "Checking Xcode Command Line Tools..."
    if ! xcode-select -p &>/dev/null; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install
    fi
    log_success "Xcode Command Line Tools ready"

    # ==========================================================================
    # Check Homebrew
    # ==========================================================================
    log_step "Checking Homebrew..."
    if ! command -v brew &>/dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi
    log_success "Homebrew ready"

    # ==========================================================================
    # Symlinks
    # ==========================================================================
    log_step "Creating symlinks..."

    # Config directory
    rm -rf ~/.config
    ln -sf "$SCRIPT_DIR/config" ~/.config
    log_success "Linked ~/.config -> $SCRIPT_DIR/config"

    # Zsh
    link_file "$SCRIPT_DIR/zsh/zshrc" "$HOME/.zshrc"
    link_file "$SCRIPT_DIR/zsh/gitconfig" "$HOME/.gitconfig"
    link_file "$SCRIPT_DIR/zsh/gitignore" "$HOME/.gitignore"
    link_directory "$SCRIPT_DIR/zsh/plugins" "$HOME/.zsh/plugins"

    # AI Skills
    if [[ -x "$SCRIPT_DIR/scripts/link-ai-skills.sh" ]]; then
        "$SCRIPT_DIR/scripts/link-ai-skills.sh"
    fi

    # ==========================================================================
    # Homebrew Packages
    # ==========================================================================
    log_step "Installing Homebrew packages..."
    if [[ -f "$SCRIPT_DIR/Brewfile" ]]; then
        brew bundle --file="$SCRIPT_DIR/Brewfile" || log_warning "Some Brewfile installs failed"
    fi
    log_success "Homebrew packages installed"

    # ==========================================================================
    # macOS Preferences
    # ==========================================================================
    log_step "Setting macOS preferences..."

    # Keyboard repeat rate (fast)
    defaults write -g KeyRepeat -int 1
    defaults write -g InitialKeyRepeat -int 10

    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show file extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Disable "Are you sure you want to open this application?"
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Disable smart quotes and dashes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable auto-correct and capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Dock settings
    defaults write com.apple.dock tilesize -int 48
    defaults write com.apple.dock magnification -bool true
    defaults write com.apple.dock largesize -int 64
    defaults write com.apple.dock orientation -string "bottom"
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock show-recents -bool true
    defaults write com.apple.dock minimize-to-application -bool true

    # Right click = secondary click
    defaults write com.apple.AppleMultitouchTrackpad SecondaryClick -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad SecondaryClick -int 1
    defaults write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

    # Trackpad tracking speed
    defaults write -g com.apple.trackpad.scaling -float 2.5

    # Kill affected apps
    killall Dock 2>/dev/null || true
    killall Finder 2>/dev/null || true

    log_success "macOS preferences set"

    # ==========================================================================
    # Caps Lock -> Escape
    # ==========================================================================
    log_info "Mapping Caps Lock to Escape..."
    
    # Apply the mapping using hidutil (works without Karabiner)
    hidutil property --set '{
        "UserKeyMapping": [
            {
                "HIDKeyCode": 0x39,
                "Replacement": {
                    "HIDKeyCode": 0x29
                }
            }
        ]
    }' 2>/dev/null || true

    # Create LaunchAgent to persist across reboots
    mkdir -p ~/Library/LaunchAgents
    cat > ~/Library/LaunchAgents/com.tcco.capslock-escape.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.tcco.capslock-escape</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyCode":57,"Replacement":{"HIDKeyCode":53}]}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

    # Load the LaunchAgent
    launchctl load ~/Library/LaunchAgents/com.tcco.capslock-escape.plist 2>/dev/null || true

    log_success "Caps Lock mapped to Escape (will persist across reboots)"

    # ==========================================================================
    # Neovim Plugins
    # ==========================================================================
    log_step "Installing Neovim plugins..."
    if command -v nvim &>/dev/null; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    fi
    log_success "Neovim plugins installed"

    # ==========================================================================
    # Done
    # ==========================================================================
    echo ""
    echo "============================================"
    echo "  Installation Complete!"
    echo "============================================"
    echo ""
    log_info "Next steps:"
    echo ""
    echo "  1. Restart terminal: source ~/.zshrc"
    echo "  2. Test neovim: nvim"
    echo ""
    echo "  Caps Lock is now mapped to Escape"
    echo "  (This will persist across reboots)"
    echo ""
    if [[ -d "$BACKUP_DIR" ]]; then
        echo "  Backups saved to: $BACKUP_DIR"
        echo ""
    fi
    echo "============================================"
}

main "$@"
