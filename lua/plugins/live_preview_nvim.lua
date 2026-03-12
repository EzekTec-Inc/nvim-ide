return {
  "brianhuster/live-preview.nvim",
  ft = { "markdown", "html", "svg" },
  config = function()
    require("livepreview").setup {
      port = 5500,
      address = "127.0.0.1",
      browser = "default",  -- uses system default browser
      sync_scroll = true,   -- sync scroll preview with editor
      dynamic_root = false,
    }

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }
    map("n", "<leader>lp", ":LivePreview<CR>", vim.tbl_extend("force", opts, { desc = "Toggle Live Preview" }))
    map("n", "<leader>ls", ":LivePreviewStop<CR>", vim.tbl_extend("force", opts, { desc = "Stop Live Preview" }))
  end,
}
