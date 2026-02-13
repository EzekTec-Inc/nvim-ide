local M = {}

M.setup = function()
  local on_attach = require("configs.lsp").on_attach
  local on_init = require("configs.lsp").on_init
  local capabilities = require("configs.lsp").capabilities
  local lspconfig = require("lspconfig")
  local util = require "lspconfig/util"

    lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    filetypes = {"rust"},
    root_dir = util.root_pattern("Cargo.toml"),
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  })
end

return M
