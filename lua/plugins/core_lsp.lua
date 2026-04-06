-- ==============================================================================
-- Module:      plugins/core_lsp
-- Description: Core Language Server Protocol and Completion plugins.
--              Manages Mason, nvim-lspconfig, nvim-cmp, and snippets.
-- ==============================================================================
return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    ensure_installed = {
      "lua-language-server", "stylua",
      "html-lsp", "css-lsp", "prettier", "typescript-language-server",
      "rust-analyzer", "marksman",
      "pyright", "clangd", "vue-language-server", "angular-language-server",
      "codelldb", "debugpy",
    },
    opts = function()
      return require "nvchad.configs.mason"
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lsp").defaults()
      require("configs.lsp").setup_lua_ls()
      require("configs.lsp").setup_ts_ls()
      require("configs.lsp").setup_other_lsps()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = "VenvSelect",
  },
  -- Tailwind
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact", "javascriptreact" },
    opts = {},
  },
  {
    "js-everts/cmp-tailwind-colors",
    ft = { "html", "svelte", "astro", "vue", "typescriptreact", "javascriptreact" },
    config = true,
  },
}
