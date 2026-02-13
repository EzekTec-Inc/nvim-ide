❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````

local M = {}
local map = vim.keymap.set

-- Require lspconfig from the plugin (use package.loaded to avoid circular require)
local lspconfig = require("lspconfig")

-- export on_attach & capabilities
````

````
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

  lspconfig.lua_ls.setup {
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````

local M = {}
local map = vim.keymap.set

-- Require lspconfig from the plugin (use package.loaded to avoid circular require)
local lspconfig = require("lspconfig")

-- export on_attach & capabilities
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````
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

  -- Require lspconfig here to avoid circular dependency at module load time
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup {
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
  }
end
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````
M.defaults = function()
  -- Require lspconfig here to avoid circular dependency during plugin loading
  local lspconfig = require("lspconfig")

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

  -- Require lspconfig here to avoid circular dependency at module load time
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup {
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````
M.defaults = function()
  -- Require lspconfig here to avoid circular dependency during plugin loading
  local lspconfig = require("lspconfig")

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

  -- Require lspconfig here to avoid circular dependency at module load time
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup {
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````
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

  -- Require lspconfig here to avoid circular dependency at module load time
  local lspconfig = require("lspconfig")

  lspconfig.lua_ls.setup {
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
  }
end
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````
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

  -- Schedule lspconfig setup to avoid circular dependency during module load
  vim.schedule(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      return
    end

    lspconfig.lua_ls.setup {
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
    }
  end)
end

return M
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# lua/configs/lspconfig.lua

Failed searches:

````
  -- Schedule lspconfig setup to avoid circular dependency during module load
  vim.schedule(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      return
    end

    lspconfig.lua_ls.setup {
````

