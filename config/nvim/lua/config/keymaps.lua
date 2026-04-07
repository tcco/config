vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>quitall<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split horizontal" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to void" })
vim.keymap.set("n", "H", "^", { desc = "Line start" })
vim.keymap.set("n", "L", "$", { desc = "Line end" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "<leader>gs", "<cmd>Git<cr>", { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff" })
vim.keymap.set("n", "<leader>v", "<cmd>NvimTreeFindFile<cr>", { desc = "Find in tree" })
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Search" })

-- vim-visual-multi custom keybindings
vim.g.VM_default_options = {
  find_by_visual = true,
  add_to_search = true,
}

-- vim-visual-multi Ctrl keybindings (Ctrl+n, Ctrl+j, Ctrl+k)
vim.keymap.set("n", "<C-n>", "<Plug>(VM-select-next)", { silent = true })
vim.keymap.set("n", "<C-j>", "<Plug>(VM-select-next)", { silent = true })  -- Down
vim.keymap.set("n", "<C-k>", "<Plug>(VM-select-previous)", { silent = true })  -- Up
