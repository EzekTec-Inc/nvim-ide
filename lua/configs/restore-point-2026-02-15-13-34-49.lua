-- RESTORE POINT: 2026-02-15T13:34:49-07:00 (Sunday)
-- This file documents the state before hardening the Treesitter ft_to_lang compatibility shim.
--
-- Error addressed:
--   Error executing vim.schedule lua callback: ...telescope/previewers/utils.lua:135:
--   attempt to call field 'ft_to_lang' (a nil value)
--
-- Root cause:
--   Neovim 0.10+ removed vim.treesitter.language.ft_to_lang, and telescope (including NvChad's
--   themes extension previewer) still calls it. The shim was being applied, but it could still
--   become nil at runtime if something clears or replaces the field later.
--
-- Fix applied:
--   - init.lua: _apply_ft_to_lang_shim now also installs a metatable fallback on
--     vim.treesitter.language, so indexing `ft_to_lang` always yields the shim even if the field
--     is cleared later.
--
-- To restore (if committed right after this change):
--   git checkout HEAD~1 -- init.lua lua/configs/restore-point-2026-02-15-13-34-49.lua

return {
  restore_date = "2026-02-15T13:34:49-07:00",
  description = "Before hardening Treesitter ft_to_lang shim for Telescope previewers",
}
