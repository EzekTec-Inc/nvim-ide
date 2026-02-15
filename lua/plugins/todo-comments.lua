-- Highlight TODO, FIXME, etc comments
-- Ported from nvim-jan-2026-working.bak
return {
  "folke/todo-comments.nvim",
  event = "BufRead",
  config = function()
    require("todo-comments").setup()
  end,
}
