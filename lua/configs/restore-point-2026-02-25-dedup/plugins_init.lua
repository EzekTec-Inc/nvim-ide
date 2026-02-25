return {
  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    lazy = false,
    build = function()
      dofile(vim.fn.stdpath "data" .. "/lazy/ui/lua/nvchad_feedback.lua")()
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = {},
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    ensure_installed = {
      "lua-language-server", "stylua",
      "html-lsp", "css-lsp", "prettier",
      "rust-analyzer",
    },
    opts = function()
      return require "nvchad.configs.mason"
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lsp").defaults()
      require("configs.lsp").setup_lua_ls()
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
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      if type(_G._apply_ft_to_lang_shim) == "function" then
        pcall(_G._apply_ft_to_lang_shim)
      end

      if type(vim.g.base46_cache) == "string" and vim.g.base46_cache ~= "" then
        pcall(dofile, vim.g.base46_cache .. "telescope")
      end

      local telescope = require "telescope"
      telescope.setup(opts)

      local extensions_list = opts.extensions_list or {}
      for _, ext in ipairs(extensions_list) do
        pcall(telescope.load_extension, ext)
      end
      pcall(telescope.load_extension, "themes")

      local ok_builtin, builtin = pcall(require, "telescope.builtin")
      if ok_builtin then
        builtin.themes = function(theme_opts)
          theme_opts = theme_opts or {}

          if type(_G._apply_ft_to_lang_shim) == "function" then
            pcall(_G._apply_ft_to_lang_shim)
          end

          if type(_G._patch_telescope_previewer_utils) == "function" then
            pcall(_G._patch_telescope_previewer_utils)
          end

          local themes_ext = telescope.extensions and telescope.extensions.themes
          if themes_ext then
            local picker = themes_ext
            if type(themes_ext) == "table" then
              picker = themes_ext.themes
            end

            if type(picker) == "function" then
              local ok_picker, err = pcall(picker, theme_opts)
              if ok_picker then
                return
              else
                if err and type(err) == "string" then
                  vim.notify("NvChad theme picker error: " .. err, vim.log.levels.WARN)
                end
              end
            end
          end

          if type(builtin.colorscheme) == "function" then
            local ok_cs, err = pcall(builtin.colorscheme, theme_opts)
            if not ok_cs and err then
              vim.notify("Colorscheme fallback error: " .. tostring(err), vim.log.levels.ERROR)
            end
            return
          end

          vim.notify("No theme picker available", vim.log.levels.ERROR)
        end
      end

      if type(_G._apply_telescope_nvchad_themes_picker) == "function" then
        pcall(_G._apply_telescope_nvchad_themes_picker)
      end
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      user_default_options = { names = false },
      filetypes = {
        "*",
        "!lazy",
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "numToStr/FTerm.nvim",
    lazy = false,
    keys = {
      { "<A-f>", function() require("FTerm").toggle() end, mode = { "n", "t" }, desc = "Toggle floating terminal" },
      { "<A-i>", function() require("FTerm").toggle() end, mode = { "n", "t" }, desc = "Toggle floating terminal" },
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
    keys = {
      { "<A-h>", function() require("toggleterm").toggle(1, 15, vim.loop.cwd(), "horizontal") end, mode = { "n", "t" }, desc = "Toggle horizontal terminal" },
    },
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
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 3,
        },
      })
    end,
  },

  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- Colorschemes
  { "rktjmp/lush.nvim" },
  { "sainnhe/edge" },
  { "sho-87/kanagawa-paper.nvim" },
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 650,
    dependencies = { "rktjmp/lush.nvim" },
  },
  {
    "tiagovla/tokyodark.nvim",
    config = function(_, opts)
      require("tokyodark").setup(opts or {})
    end,
  },

  {
    "CosmicNvim/cosmic-ui",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("cosmic-ui").setup()
    end,
  },

  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = "VenvSelect",
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
  {
    "razak17/tailwind-fold.nvim",
    opts = {
      min_chars = 50,
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "html", "svelte", "astro", "vue", "typescriptreact", "javascriptreact" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
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
    event = "BufEnter",
    config = function()
      vim.keymap.set("i", "<C-g>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-Tab>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
    end,
  },
}
