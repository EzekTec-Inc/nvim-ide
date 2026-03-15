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
  end,
}
