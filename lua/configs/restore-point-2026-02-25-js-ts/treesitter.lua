-- Restore point: 2026-02-13T22:07:02-07:00
-- Fixed: nvim-treesitter-textobjects config for nvim-treesitter 1.0+
-- The nvim-treesitter.configs module no longer exists in nvim-treesitter 1.0+
-- Textobjects configuration is handled separately
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  dependencies = {
    -- Note: textobjects plugin - no config function needed for nvim-treesitter 1.0+
    "nvim-treesitter/nvim-treesitter-textobjects",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "windwp/nvim-ts-autotag",
  },
  opts = {
    indent = { enable = true },
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

    autotag = {
      enable = true,
    },

    auto_install = true,
    autopairs = {
      enable = true,
    },

    highlight = {
      enable = true,
      use_languagetree = true,
      disable = function()
        return vim.b.large_buf
      end,
      additional_vim_regex_highlighting = false,
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

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  },

  config = function(_, opts)
    pcall(function()
      if vim.g.base46_cache and type(vim.g.base46_cache) == "string" then
        dofile(vim.g.base46_cache .. "syntax")
        dofile(vim.g.base46_cache .. "treesitter")
      end
    end)

    local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
    if ok and ts_configs and ts_configs.setup then
      ts_configs.setup(opts)
    end
  end,
}
