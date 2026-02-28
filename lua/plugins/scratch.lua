return {
  "LintaoAmons/scratch.nvim",
  event = "VeryLazy",
  cmd = { "Scratch", "ScratchOpen", "ScratchNew" },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("scratch").setup({
      scratch_file_dir = vim.fn.stdpath("data") .. "/scratch",
      window_config = {
        relative = "editor",
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
      use_fonts_awesome = true,
    })
  end,
}
