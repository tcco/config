-- Neovim Configuration
-- Modern setup with lazy.nvim + native LSP

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy")
require("config.keymaps")
require("config.lsp")

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.cmdheight = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.timeoutlen = 300
vim.opt.updatetime = 300
vim.opt.fillchars = { eob = " " }
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", extends = "»", precedes = "«", nbsp = "␣" }
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>")
vim.opt.foldlevel = 99
vim.opt.foldenable = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.diffopt = "vertical,algorithm:patience,indent-heuristic"
vim.cmd("syntax on")
vim.cmd("colorscheme tokyonight")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "yaml", "markdown" },
  callback = function() vim.opt_local.tabstop = 2 vim.opt_local.shiftwidth = 2 vim.opt_local.softtabstop = 2 end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then vim.api.nvim_exec("normal! g'\"", false) end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 }) end,
})
