local M = {}

M.setup = function()
  local lsp = require("configs.lsp")
  local util = require "lspconfig/util"

  lsp.setup_lsp("rust_analyzer", {
    on_attach = lsp.on_attach,
    on_init = lsp.on_init,
    capabilities = lsp.capabilities,
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
