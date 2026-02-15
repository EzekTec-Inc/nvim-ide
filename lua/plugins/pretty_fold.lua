return {
  "anuvyklack/pretty-fold.nvim",
  event = "BufReadPost",
  dependencies = { "anuvyklack/keymap-amend.nvim" },
  config = function()
    require("pretty-fold").setup {}
  end,
}
