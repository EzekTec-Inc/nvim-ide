return {
  "roobert/activate.nvim",
  keys = {
    { "<leader>P", "<CMD>lua require(\"activate\").list_plugins()<CR>", desc = "Plugins" },
    { "<leader>pP", '<CMD>lua require("activate").list_plugins()<CR>', desc = "List Plugins" },
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
  }
}
