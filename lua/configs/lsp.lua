-- ==============================================================================
-- Module:      configs/lsp
-- Description: Custom LSP setup compatible with Neovim 0.11+ core APIs
--              (vim.lsp.config/enable) with fallback to nvim-lspconfig.
-- ==============================================================================
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
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  -- LSP rename via Lspsaga (UI-consistent)
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts "Lspsaga rename")

end

-- LSP flags for performance
M.flags = {
  debounce_text_changes = 150,
}

-- disable semanticTokens
M.on_init = function(client, _)
  if client.server_capabilities and client.server_capabilities.semanticTokensProvider then
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
    -- In Nvim 0.11, we should avoid require('lspconfig') if possible
    -- but we still need to check if the server is executable to avoid spawning errors
    
    -- Try to get existing config from core
    local config = vim.lsp.config[name]
    
    -- If not found in core, try to find it in nvim-lspconfig without triggering the main framework warning
    if not config then
      local ok, lspconfig_configs = pcall(require, "lspconfig.configs")
      if ok and lspconfig_configs[name] then
        config = lspconfig_configs[name]
      end
    end

    local final_opts = opts or {}
    local cmd = final_opts.cmd
    
    -- If we don't have a cmd in opts, try to get it from the config
    if not cmd and config and config.default_config then
      cmd = config.default_config.cmd
    end

    -- Handle cmd as a function (common in Nvim 0.11 configs like angularls)
    if type(cmd) == "function" then
      -- Angular LSP (angularls) in nvim-lspconfig for Nvim 0.11 uses a function for cmd.
      -- However, the inner call to vim.lsp.rpc.start will fail if 'ngserver' is missing.
      -- We add an extra check specifically for 'ngserver' if the server name is 'angularls'.
      if name == "angularls" and vim.fn.executable("ngserver") == 0 then
        return
      end
      
      -- For other function-based cmds, we trust they handle missing binaries
      -- or at least don't crash the editor.
      if opts then
        vim.lsp.config(name, opts)
      end
      vim.lsp.enable(name)
      return
    end

    -- Check if executable exists before enabling
    if cmd and type(cmd) == "table" and #cmd > 0 then
      local executable = cmd[1]
      -- For some servers, the first element might be a full path or just a command name
      if vim.fn.executable(executable) == 1 then
        if opts then
          vim.lsp.config(name, opts)
        end
        vim.lsp.enable(name)
      end
    elseif cmd and type(cmd) == "string" then
      if vim.fn.executable(cmd) == 1 then
        if opts then
          vim.lsp.config(name, opts)
        end
        vim.lsp.enable(name)
      end
    else
      -- Fallback: if no cmd, try to see if name itself is executable as a guess
      if vim.fn.executable(name) == 1 then
        if opts then
          vim.lsp.config(name, opts)
        end
        vim.lsp.enable(name)
      end
    end
  else
    local ok, lspconfig = pcall(require, "lspconfig")
    if ok and lspconfig[name] then
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
    flags = M.flags,

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
    flags = M.flags,
  })
end

M.setup_other_lsps = function()
  local servers = { "html", "cssls", "pyright", "clangd", "volar", "angularls", "marksman" }

  for _, lsp in ipairs(servers) do
    M.setup_lsp(lsp, {
      on_attach = M.on_attach,
      on_init = M.on_init,
      capabilities = M.capabilities,
      flags = M.flags,
    })
  end
end

return M


