return {
  "mrcjkb/rustaceanvim",
  version = "^4",
  ft = { "rust" },
  dependencies = "neovim/nvim-lspconfig",
  config = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          local map = vim.keymap.set
          local opts = { buffer = bufnr, silent = true }
          map("n", "<leader>ca", function() vim.cmd.RustLsp('codeAction') end, opts)
          map("n", "K", function() vim.cmd.RustLsp({'hover', 'actions'}) end, opts)
        end,
      },
    }
  end,
}
