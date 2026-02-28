return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  ft = { "rust" },
  dependencies = "neovim/nvim-lspconfig",
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          local lsp = require("configs.lsp")
          lsp.on_attach(client, bufnr)
          local map = vim.keymap.set
          map({ "n", "v" }, "<leader>ca", function() vim.cmd.RustLsp('codeAction') end, { buffer = bufnr, desc = "LSP Code Action (Rust)" })
          map("n", "K", function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, { buffer = bufnr, desc = "LSP Hover (Rust)" })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              buildScripts = { enable = true },
            },
            procMacro = {
              enable = true,
              attributes = { enable = true },
            },
          },
        },
      },
    }
  end,
}
