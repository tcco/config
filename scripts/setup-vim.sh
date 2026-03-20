#!/bin/bash
# mvim/Neovim setup script

set -e

echo "Installing macvim and neovim..."

# Install macvim and neovim
brew install macvim neovim

# Create nvim config directory structure
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.local/share/nvim/undo

# Link the modern init.lua (if not already linked)
if [ ! -f ~/.config/nvim/init.lua ]; then
    ln -sf ~/config/.config/nvim/init.lua ~/.config/nvim/init.lua
fi

# Install formatters/linters for conform.nvim
echo "Installing formatters..."
npm install -g prettierd eslint_d
pip install black isort

# Open neovim to trigger lazy.nvim plugin installation
echo "Opening neovim to install plugins..."
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

echo ""
echo "Done! Run 'nvim' to use."
echo "Key mappings:"
echo "  <leader>e  - Toggle file tree (NvimTree)"
echo "  <leader>ff - Telescope find files"
echo "  <leader>fg - Telescope live grep"
echo "  <leader>fb - Telescope buffers"
echo "  gd         - Go to definition"
echo "  K          - Hover documentation"
echo "  <leader>ca - Code actions"
echo "  <leader>xx - Trouble diagnostics"
