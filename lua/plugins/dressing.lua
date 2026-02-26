return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  config = function()
    require("dressing").setup({
      input = {
        win_options = { winblend = 0 },
      },
      select = {
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
      },
    })
  end,
}
