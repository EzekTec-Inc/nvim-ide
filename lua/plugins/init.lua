-- return {
--   {
--     "stevearc/conform.nvim",
--     -- event = 'BufWritePre', -- uncomment for format on save
--     config = function()
--       require "configs.conform"
--     end,
--   },

  -- These are some examples, uncomment them if you want to see them work!
  -- {
  --   "neovim/nvim-lspconfig",
  --   config = function()
  --     require("nvchad.configs.lspconfig").defaults()
  --     require "configs.lspconfig"
  --   end,
  -- },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
-- }
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

  -- file managing , picker etc
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

  -- formatting!
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    ensure_installed = {
      "lua-language-server", "stylua",
      "html-lsp", "css-lsp" , "prettier",
      "rust-analyzer"
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
    end
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lsp").defaults()
      require("configs.lsp").setup_lua_ls()
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
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

      -- load extensions
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

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  -- floating terminal
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

  -- toggleable horizontal terminal
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

  -- toggleterm manager
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },

  -- nvim-surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  -- smooth screen scrolling on cursor movement
  {
    "declancm/cinnamon.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Hop (Better Navigation)
  {
    "phaazon/hop.nvim",
    lazy = true,
    cmd = { "HopWord", "HopLine", "HopChar1", "HopChar2" },
    config = function()
      require("hop").setup({})
    end,
  },

  -- confirm quit
  {
    "yutkat/confirm-quit.nvim",
    event = "CmdlineEnter",
    opts = {},
  },

  -- Quick startup
  {
    "lewis6991/impatient.nvim",
    lazy = false,
    priority = 1000,
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- Zen Mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {},
  },

  -- Persistence (session management)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup {
        dir = vim.fn.expand(vim.fn.stdpath "config" .. "/session/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
      }
    end,
  },

  -- Trouble diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {},
    keys = {
      { "<leader>tt", "<cmd>TroubleToggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>tX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>to", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>tQ", "<cmd>Trouble quickfix toggle<cr>", desc = "Quickfix List (Trouble)" },
      { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", desc = "Lsp References (Trouble)" },
    },
  },

  -- thePrimeagen's Harpoon
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup({})
    end,
  },

  -- crates.nvim for Cargo.toml
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup {}
    end,
  },

  -- text toggler
  {
    "rmagatti/alternate-toggler",
    event = "VeryLazy",
    config = function()
      require("alternate-toggler").setup {
        alternates = {
          ["Vec::new();"] = "vec!",
          ["enum"] = "struct",
          ["struct"] = "enum",
          ["const"] = "let",
          ["let"] = "const",
          ["true"] = "false",
          ["True"] = "False",
          ["TRUE"] = "FALSE",
          ["Yes"] = "No",
          ["YES"] = "NO",
          ["on"] = "off",
          ["ON"] = "OFF",
          ["1"] = "0",
          ["<"] = ">",
          ["("] = ")",
          ["["] = "]",
          ["{"] = "}",
          ['"'] = "'",
          ['""'] = "''",
          ["+"] = "-",
          ["="] = "==",
          ["!="] = "==",
          ["==="] = "!==",
          ["=="] = "!=",
          ["NOTE:"] = "FIXME:",
          ["error"] = "warn",
        },
      }
    end,
  },

  -- Split/Join Lines
  {
    "Wansmer/treesj",
    lazy = true,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<space>m", "<cmd>TSJToggle<CR>", desc = "Toggle Split/Join" },
      { "<space>j", "<cmd>TSJSplit<CR>", desc = "Code Split" },
      { "<space>s", "<cmd>TSJJoin<CR>", desc = "Code Join" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({
        use_default_keymaps = true,
      })
    end,
  },

  -- Action hints
  {
    "roobert/action-hints.nvim",
    event = "LspAttach",
    config = function()
      require("action-hints").setup({
        template = {
          definition = { text = " ⊛", color = "#add8e6" },
          references = { text = " ↱%s", color = "#ff6666" },
        },
        use_virtual_text = true,
      })
    end,
  },

  -- Code Folding
  { "anuvyklack/keymap-amend.nvim", lazy = true },
  {
    "anuvyklack/pretty-fold.nvim",
    event = "BufReadPost",
    config = function()
      require("pretty-fold").setup {}
    end,
  },

  -- Code snippet screenshot
  {
    "ellisonleao/carbon-now.nvim",
    lazy = true,
    cmd = "CarbonNow",
    opts = {
      base_url = "https://carbon.now.sh/",
      options = {
        bg = "gray",
        drop_shadow_blur = "68px",
        drop_shadow = false,
        drop_shadow_offset_y = "20px",
        font_family = "Hack",
        font_size = "18px",
        line_height = "133%",
        line_numbers = true,
        theme = "monokai",
        titlebar = "Code-snippet",
        watermark = false,
        width = "680",
        window_theme = "sharp",
        padding_horizontal = "0px",
        padding_vertical = "0px",
      },
    },
  },

  -- LSP kind icons
  {
    "onsails/lspkind.nvim",
    event = "LspAttach",
  },

  -- LSP progress
  {
    "linrongbin16/lsp-progress.nvim",
    event = "LspAttach",
    config = function()
      require("lsp-progress").setup()
    end,
  },

  -- Colorscheme
  { "rktjmp/lush.nvim" },
  { "sainnhe/edge" },
  {
    "sho-87/kanagawa-paper.nvim",
  },
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

  -- Cosmic UI
  {
    "CosmicNvim/cosmic-ui",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("cosmic-ui").setup()
    end,
  },

  -- venv selector
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = "VenvSelect",
  },

  -- LSP colors
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },

  -- edgy window manager
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {}
  },

  -- mini.ai for enhanced text objects
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

  -- mini.nvim
  { "echasnovski/mini.nvim", version = "*" },

  -- Tiny Dev-icons-auto-colors
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
      require("tiny-devicons-auto-colors").setup()
    end,
  },

  -- tailwind tools
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
    end
  },

  -- Leptos tree-sitter-rstml
  {
    "rayliwell/tree-sitter-rstml",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    build = ":TSUpdate",
    ft = "rust",
    config = function()
      require("tree-sitter-rstml").setup()
    end
  },

  -- consolation terminal
  {
    "pianocomposer321/consolation.nvim",
    cmd = { "Console" },
  },

  -- codeium AI code completion
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
