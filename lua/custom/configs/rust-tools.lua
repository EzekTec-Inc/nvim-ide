local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities

local options = {
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  }
}

return options
