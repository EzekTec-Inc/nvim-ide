-- RESTORE POINT: 2026-02-13T22:04:22-07:00
-- Note: impatient.nvim is deprecated as Neovim 0.9+ has built-in caching via vim.loader
-- This plugin is kept for compatibility but may be removed in future updates.
--
-- If you encounter errors with this plugin, you can safely delete this file
-- as Neovim's built-in loader provides similar functionality.

return {
  "lewis6991/impatient.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  config = function()
    local ok, impatient = pcall(require, "impatient")
    if ok then
      impatient.enable_profile()
    end
  end,
}
