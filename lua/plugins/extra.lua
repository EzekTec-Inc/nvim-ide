-- Extra plugins from backup config
return {
  -- smooth screen UI/ui scrolling on cursor movement
  {
    "declancm/cinnamon.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Hop (Better Navigation)
  {
    "phaazon/hop.nvim",
    event = "VeryLazy",
    config = function()
      require("hop").setup()
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

  -- fidget LSP progress
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

  -- Persistence (session)
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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

  -- Tiny Dev-icons-auto-colors
  {
    "rachartier/tiny-devicons-auto-colors.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
      require("tiny-devicons-auto-colors").setup()
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

  -- crates.nvim for Cargo.toml
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
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
}
