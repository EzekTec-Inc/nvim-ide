return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup({
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = 'global',
    })
    require("telescope").load_extension("projects")
  end,
  keys = {
    { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find Projects" },
  },
}