return {
  "brianhuster/live-preview.nvim",
  build = "npm install",
  ft = { "markdown", "html", "vue" },
  config = function()
    require("live_preview").setup {
      -- Enable mermaid diagram rendering
      mermaid_enabled = true,

      -- Port for the preview server (default: 5500)
      port = 5500,

      -- Auto-open preview in browser on startup
      browser = "firefox", -- or "chrome", "chromium", etc.

      -- Auto-refresh on file save
      auto_refresh = true,

      -- Show live preview on the right side (optional)
      position = "right",
    }

    -- Keymaps for live-preview
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Start/stop live preview
    map("n", "<leader>lp", ":LivePreview<CR>", vim.tbl_extend("force", opts, { desc = "Toggle Live Preview" }))
    map("n", "<leader>ls", ":LivePreviewStop<CR>", vim.tbl_extend("force", opts, { desc = "Stop Live Preview" }))
  end,
}
