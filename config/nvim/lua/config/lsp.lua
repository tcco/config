local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.diagnostic.config({
  virtual_text = { prefix = "▎" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { focusable = false, style = "minimal", border = "rounded" }
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float)

vim.lsp.config('*', {
  on_attach = function(client, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
  capabilities = capabilities,
})

vim.lsp.config('pyright', {})
vim.lsp.config('ruff', {})
vim.lsp.config('ts_ls', {})
vim.lsp.config('html', {})
vim.lsp.config('cssls', {})
vim.lsp.config('jsonls', {})
vim.lsp.config('yamlls', {})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) }
    }
  }
})
vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" }
    }
  }
})
vim.lsp.config('gopls', {})
vim.lsp.config('bashls', {})
vim.lsp.config('marksman', {})
vim.lsp.config('dockerls', {})
