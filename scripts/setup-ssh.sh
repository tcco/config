#!/bin/bash

# SSH Key Setup Helper Script
# Generates SSH keys and helps add them to GitHub

set -e

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

# Get user email
read -p "Enter your email address: " email

if [[ -z "$email" ]]; then
    log_error "Email is required"
    exit 1
fi

# Generate SSH key
ssh_key_path="$HOME/.ssh/id_ed25519"

if [[ -f "$ssh_key_path" ]]; then
    log_warning "SSH key already exists at $ssh_key_path"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Keeping existing SSH key"
    else
        log_info "Generating new SSH key..."
        ssh-keygen -t ed25519 -C "$email" -f "$ssh_key_path" -N ""
        log_success "SSH key generated"
    fi
else
    log_info "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$ssh_key_path" -N ""
    log_success "SSH key generated"
fi

# Start SSH agent and add key
log_info "Starting SSH agent and adding key..."
eval "$(ssh-agent -s)"
ssh-add "$ssh_key_path"

# Copy public key to clipboard
if command -v pbcopy &> /dev/null; then
    pbcopy < "${ssh_key_path}.pub"
    log_success "Public key copied to clipboard!"
else
    log_warning "pbcopy not available. Here's your public key:"
    cat "${ssh_key_path}.pub"
fi

# Instructions for GitHub
echo
log_info "Next steps:"
log_info "1. Go to GitHub → Settings → SSH and GPG keys"
log_info "2. Click 'New SSH key'"
log_info "3. Paste the key from your clipboard"
log_info "4. Test with: ssh -T git@github.com"

# Optionally open GitHub
read -p "Open GitHub SSH settings in browser? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "https://github.com/settings/ssh/new"
fi