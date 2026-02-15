return {
  "phaazon/hop.nvim",
  lazy = true,
  cmd = { "HopWord", "HopLine", "HopChar1", "HopChar2" },
  keys = {
    { "<leader>hw", "<cmd>HopWord<cr>", desc = "Hop Word" },
    { "<leader>hl", "<cmd>HopLine<cr>", desc = "Hop Line" },
    { "<leader>hc", "<cmd>HopChar1<cr>", desc = "Hop Char" },
  },
  config = function()
    require("hop").setup()
  end,
}
