-- ==============================================================================
-- Module:      plugins/core_utils
-- Description: Core Utility plugins.
--              Manages Formatting (conform.nvim), UI components, AI, etc.
-- ==============================================================================
return {
  "nvim-lua/plenary.nvim",
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "numToStr/FTerm.nvim",
    lazy = false,
    keys = {
      { "<A-f>", function() require("FTerm").toggle() end, mode = { "n", "t" }, desc = "Toggle floating terminal" },
    },
    config = function()
      require("FTerm").setup({
        border = "double",
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },
  -- nvim-surround moved to lua/plugins/nvim_surround.lua

  {
    "CosmicNvim/cosmic-ui",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("cosmic-ui").setup()
    end,
  },
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    event = "VeryLazy",
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
  { "echasnovski/mini.nvim", version = "*" },
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },
  -- Leptos RSX syntax
  {
    "rayliwell/tree-sitter-rstml",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = ":TSUpdate",
    ft = "rust",
    config = function()
      require("tree-sitter-rstml").setup()
    end,
  },
  {
    "pianocomposer321/consolation.nvim",
    cmd = { "Console" },
  },
  {
    "Exafunction/codeium.vim",
    enabled = true,
    event = "BufEnter",
  },
}
