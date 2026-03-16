return {
  "gbprod/yanky.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    -- default settings
  },
  config = function(_, opts)
    require("yanky").setup(opts)
    require("telescope").load_extension("yank_history")
  end,
  keys = {
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
    { "]y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
    { "[y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
    { "<leader>sy", "<cmd>Telescope yank_history<cr>", desc = "Telescope Yank History" },
  },
}