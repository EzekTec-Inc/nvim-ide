-- Restore Point: 2026-02-13T23:52:49-07:00
-- Description: Fix for Telescope ft_to_lang error using metatable proxy
--
-- Error fixed:
--   attempt to call field 'ft_to_lang' (a nil value)
--   at telescope.nvim/lua/telescope/previewers/utils.lua:135
--
-- Root Cause:
--   vim.treesitter.language.ft_to_lang was removed in Neovim 0.10+
--   Telescope's previewer utils still call this function
--   Previous shim attempts using rawset and timers were not reliable
--
-- Solution:
--   Use a metatable proxy on vim.treesitter.language that:
--   1. Always returns ft_to_lang_shim when "ft_to_lang" is accessed
--   2. Prevents ft_to_lang from being set to nil
--   3. Forwards all other accesses to the original table contents
--
-- Files modified:
--   - init.lua (replaced timer/autocmd shim with metatable proxy)
--
-- To restore previous state:
--   In init.lua, replace the metatable proxy block with the previous
--   timer-based approach. However, this will reintroduce the error.
--
-- To completely remove the fix (not recommended):
--   Remove the entire `do...end` block after `vim.g.mapleader = " "`
--   This will cause Telescope preview errors on Neovim 0.10+

return {
  created = "2026-02-13T23:52:49-07:00",
  description = "Fix Telescope ft_to_lang error using metatable proxy",
  files_modified = {
    "init.lua",
  },
}
