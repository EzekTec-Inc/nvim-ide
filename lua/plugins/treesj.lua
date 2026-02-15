return {
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
}
