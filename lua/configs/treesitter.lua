pcall(function()
  if vim.g.base46_cache and type(vim.g.base46_cache) == "string" then
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
  end
end)

-- FIX 2026-02-13T23:47:40: ft_to_lang shim is defined in init.lua before lazy.nvim loads

local options = {
  ensure_installed = {
    "lua",
    "luadoc",
    "printf",
    "vim",
    "vimdoc",
    "bash",
    "c",
    "diff",
    "html",
    "rust",
    "json",
    "javascript",
    "markdown",
    "python",
    "query",
    "toml",
    "yaml",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
    disable = function()
      return vim.b.large_buf
    end,
    additional_vim_regex_highlighting = false,
  },

  indent = { enable = true },

  auto_install = true,

  autopairs = {
    enable = true,
  },

  autotag = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-leader>",
      node_incremental = "<C-leader>",
      scope_incremental = "<nop>",
      node_decremental = "<bs>",
    },
  },

  context_commentstring = { enable = true },

  rainbow = {
    enable = true,
    extended_mode = true,
    colors = {
      "#ff6188",
      "#fc9867",
      "#ffd866",
      "#a9dc76",
      "#78dce8",
      "#ab9df2",
    },
  },
}

return options
