-- Restore point created: 2026-02-13T21:44:32-07:00
-- Updated: 2026-02-13T23:39:50-07:00
-- This file documents the state before implementing backup configuration features
--
-- To restore, you can reference these original configurations and manually
-- revert any changes made after this date.
--
-- Files modified:
-- - lua/mappings.lua
-- - lua/plugins/init.lua
-- - lua/configs/utils.lua (new)
--
-- New plugins added:
-- - bigfile.nvim
-- - cloak.nvim
-- - vim-illuminate
-- - inlay-hints.nvim
-- - legendary.nvim (with duplicate.nvim)
-- - lsp-progress.nvim
-- - lspkind.nvim
-- - lspsaga.nvim
-- - rustaceanvim
-- - neovim-session-manager
--
-- To fully restore, delete or comment out the new plugin entries in lua/plugins/init.lua
-- and revert lua/mappings.lua changes.
--
-- Latest Fix 2026-02-13T23:39:50-07:00:
--   Fixed Telescope ft_to_lang error by making the treesitter language shim
--   unconditionally override and return empty string for nil inputs.
--   See lua/restore_points/2026-02-13_telescope_ft_to_lang_fix.md for details.

return {
  restore_date = "2026-02-13T21:44:32-07:00",
  updated = "2026-02-13T23:39:50-07:00",
  description = "Pre-backup-merge restore point",
}
