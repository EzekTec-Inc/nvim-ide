-- nvim-ufo — modern LSP-aware code folding
-- Providers: LSP first (most accurate), treesitter as fallback, indent as last resort.
-- foldingRange capability is already declared in configs/lsp.lua → M.capabilities.
--
-- Keymaps (defined in mappings.lua, repeated here for reference):
--   zR  → open all folds
--   zM  → close all folds
--   zr  → open folds except kinds
--   zm  → close folds with
--   zk  → peek folded lines under cursor (does NOT open the fold)
return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = { "BufReadPost", "BufNewFile" },

  init = function()
    -- These must be set before ufo loads
    vim.o.foldcolumn    = "1"  -- shows fold indicators in the sign column
    vim.o.foldlevel     = 99   -- start with all folds open
    vim.o.foldlevelstart = 99
    vim.o.foldenable    = true
  end,

  opts = {
    -- LSP → treesitter → indent, per buffer
    provider_selector = function(_, filetype, buftype)
      -- Filetypes where treesitter is more reliable than LSP folding
      local ts_only = { "markdown", "yaml", "toml", "html", "css" }
      if vim.tbl_contains(ts_only, filetype) then
        return { "treesitter", "indent" }
      end
      -- For special buftypes (quickfix, nofile, etc.) use indent only
      if buftype ~= "" then
        return "indent"
      end
      return { "lsp", "treesitter" }
    end,

    -- Virtual text appended to a closed fold showing how many lines are hidden
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = ("  󰁂 %d lines"):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0

      for _, chunk in ipairs(virtText) do
        local chunkText  = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end

      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end,

    -- Preview window config (used by zk / peekFoldedLinesUnderCursor)
    preview = {
      win_config = {
        border      = "rounded",
        winhighlight = "Normal:Normal",
        winblend    = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
        jumpTop = "[",
        jumpBot = "]",
      },
    },
  },

  config = function(_, opts)
    require("ufo").setup(opts)
  end,
}
