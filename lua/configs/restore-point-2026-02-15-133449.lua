-- RESTORE POINT: 2026-02-15T13:34:49-07:00 (Sunday)
-- This file documents the state before making the Treesitter ft_to_lang shim persistent.
--
-- To restore, revert the following files to their state before this date:
--   - init.lua
--
-- Changes made:
--   1. init.lua: Installed a vim.treesitter.language proxy so ft_to_lang is always available,
--      and wrapped future vim.treesitter.language assignments to prevent regression.
--
-- Git command to restore (if committed):
--   git checkout HEAD~1 -- init.lua

return {
  restore_date = "2026-02-15T13:34:49-07:00",
  description = "Before making Treesitter ft_to_lang shim persistent via proxy",
}
