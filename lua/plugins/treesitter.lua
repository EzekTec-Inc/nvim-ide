-- nvim-treesitter + nvim-treesitter-textobjects
-- Uses the new standalone textobjects API (nvim-treesitter 1.0+)
-- textobjects are configured directly via require("nvim-treesitter-textobjects.*")
return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    opts = {
      ensure_installed = {
        "lua", "luadoc", "printf", "vim", "vimdoc",
        "bash", "c", "diff", "html", "css",
        "rust", "json", "javascript", "typescript", "tsx",
        "markdown", "markdown_inline",
        "python", "query", "toml", "yaml", "mermaid",
      },

      auto_install = true,

      highlight = {
        enable = true,
        use_languagetree = true,
        disable = function() return vim.b.large_buf end,
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },

      autopairs  = { enable = true },
      autotag    = { enable = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection   = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },

      context_commentstring = { enable = true },

      rainbow = {
        enable = true,
        extended_mode = true,
        colors = {
          "#ff6188", "#fc9867", "#ffd866",
          "#a9dc76", "#78dce8", "#ab9df2",
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

      local ok, ts = pcall(require, "nvim-treesitter")
      if ok and ts and ts.setup then
        ts.setup(opts)
      end
    end,
  },

  -- ── nvim-treesitter-textobjects ──────────────────────────────────────────
  -- Standalone plugin (nvim-treesitter 1.0+). Config is done here, NOT inside
  -- nvim-treesitter's opts table.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    config = function()
      -- All config goes through the single config module
      require("nvim-treesitter-textobjects.config").update {
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",   -- linewise
            ["@class.outer"]    = "V",
            ["@parameter.inner"] = "v",  -- charwise
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      }

      local sel  = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")
      local map  = vim.keymap.set

      -- ── Select text objects ──────────────────────────────────────────────
      -- af/if  → function outer/inner
      -- ac/ic  → class outer/inner
      -- aa/ia  → argument/parameter outer/inner
      -- al/il  → loop outer/inner
      -- ai/ii  → conditional outer/inner
      map({ "x", "o" }, "af", function() sel.select_textobject("@function.outer", "textobjects") end, { desc = "TS outer function" })
      map({ "x", "o" }, "if", function() sel.select_textobject("@function.inner", "textobjects") end, { desc = "TS inner function" })
      map({ "x", "o" }, "ac", function() sel.select_textobject("@class.outer",    "textobjects") end, { desc = "TS outer class" })
      map({ "x", "o" }, "ic", function() sel.select_textobject("@class.inner",    "textobjects") end, { desc = "TS inner class" })
      map({ "x", "o" }, "aa", function() sel.select_textobject("@parameter.outer","textobjects") end, { desc = "TS outer argument" })
      map({ "x", "o" }, "ia", function() sel.select_textobject("@parameter.inner","textobjects") end, { desc = "TS inner argument" })
      map({ "x", "o" }, "al", function() sel.select_textobject("@loop.outer",     "textobjects") end, { desc = "TS outer loop" })
      map({ "x", "o" }, "il", function() sel.select_textobject("@loop.inner",     "textobjects") end, { desc = "TS inner loop" })
      map({ "x", "o" }, "ai", function() sel.select_textobject("@conditional.outer","textobjects") end, { desc = "TS outer conditional" })
      map({ "x", "o" }, "ii", function() sel.select_textobject("@conditional.inner","textobjects") end, { desc = "TS inner conditional" })

      -- ── Move between text objects ────────────────────────────────────────
      -- ]m/[m  → next/prev function start
      -- ]M/[M  → next/prev function end
      -- ]/[    → next/prev class start
      -- ]a/[a  → next/prev argument
      map({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer",    "textobjects") end, { desc = "Next function start" })
      map({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer","textobjects") end, { desc = "Prev function start" })
      map({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer",      "textobjects") end, { desc = "Next function end" })
      map({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer",  "textobjects") end, { desc = "Prev function end" })
      map({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer",       "textobjects") end, { desc = "Next class start" })
      map({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer",   "textobjects") end, { desc = "Prev class start" })
      map({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner",   "textobjects") end, { desc = "Next argument" })
      map({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner","textobjects") end, { desc = "Prev argument" })

      -- ── Swap arguments ───────────────────────────────────────────────────
      -- <leader>sa → swap with next argument
      -- <leader>sA → swap with previous argument
    end,
  },
}
