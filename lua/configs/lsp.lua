-- FIX 2026-02-13T23:40:46: ft_to_lang shim is now centralized in init.lua using _G

local M = {}
local map = vim.keymap.set

-- export on_attach & capabilities
M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc, noremap = true, silent = true }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  -- map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>ra", function()
    require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")

  -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
end

-- disable semanticTokens
M.on_init = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.setup_lsp = function(name, opts)
  if vim.fn.has("nvim-0.11") == 1 then
    pcall(require, "lspconfig")
    if opts then
      vim.lsp.config(name, opts)
    end
    vim.lsp.enable(name)
  else
    local ok, lspconfig = pcall(require, "lspconfig")
    if ok then
      lspconfig[name].setup(opts)
    end
  end
end

M.defaults = function()
  local base46_cache = vim.g.base46_cache
  if type(base46_cache) == "string" and base46_cache ~= "" then
    local lsp_cache = base46_cache .. "lsp"
    local readable = vim.fn.filereadable(lsp_cache)
    if readable == 1 or readable == true then
      pcall(dofile, lsp_cache)
    end
  end

  -- Configure diagnostics
  local config = {
    virtual_text = { spacing = 4, prefix = "●" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }
  vim.diagnostic.config(config)
end

M.setup_lua_ls = function()
  M.setup_lsp("lua_ls", {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    on_init = M.on_init,

    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            vim.fn.expand "$VIMRUNTIME/lua",
            vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
            vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
            vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  })
end

M.setup_ts_ls = function()
  M.setup_lsp("ts_ls", {
    on_attach = M.on_attach,
    on_init = M.on_init,
    capabilities = M.capabilities,
  })
end

M.setup_other_lsps = function()
  local servers = { "html", "cssls", "pyright", "clangd", "volar", "angularls" }

  for _, lsp in ipairs(servers) do
    M.setup_lsp(lsp, {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
    })
  end
end

-- Create LineLeadCharToggle command if not already defined
if vim.fn.exists(':LineLeadCharToggle') == 0 then
  local line_lead_char_enabled = true
  vim.api.nvim_create_user_command("LineLeadCharToggle", function()
    line_lead_char_enabled = not line_lead_char_enabled
    if line_lead_char_enabled then
      vim.opt.list = true
      print("Line lead chars enabled")
    else
      vim.opt.list = false
      print("Line lead chars disabled")
    end
  end, { desc = "Toggle line lead characters" })
end

return M


 
-- -- EXAMPLE 
-- local on_attach = require("nvchad.configs.lspconfig").on_attach
-- local on_init = require("nvchad.configs.lspconfig").on_init
-- local capabilities = require("nvchad.configs.lspconfig").capabilities
--
-- local lspconfig = require("lspconfig")
-- local util = require "lspconfig/util"
-- local servers = { "html", "cssls" }
--
-- -- lsps with default config
-- for _, lsp in ipairs(servers) do
--   lspconfig[lsp].setup {
--     on_attach = on_attach,
--     on_init = on_init,
--     capabilities = capabilities,
--   }
-- end
--
-- -- typescript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   on_init = on_init,
--   capabilities = capabilities,
-- }
--
-- -- -- rust
-- -- lspconfig.rust_analyzer.setup({
-- --   on_attach = on_attach,
-- --   capabilities = capabilities,
-- --   filetypes = {"rust"},
-- --   root_dir = util.root_pattern("Cargo.toml"),
-- --   settings = {
-- --     ['rust-analyzer'] = {
-- --       cargo = {
-- --         allFeatures = true,
-- --       },
-- --     },
-- --   },
-- -- })
