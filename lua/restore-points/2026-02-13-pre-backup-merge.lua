-- Restore Point: 2026-02-13T21:42:01-07:00
-- Updated: 2026-02-13T23:15:30-07:00
-- Description: State before merging features from nvim-jan-2026-working.bak
-- To restore: Copy relevant sections back to their original files

-- This file documents the state of key files before the backup merge.
-- Files affected:
--   - lua/mappings.lua
--   - lua/plugins/init.lua
--   - lua/autocmds.lua

-- RESTORE INSTRUCTIONS:
-- 1. If you need to reverse changes, check git history or
-- 2. Compare current files with the documented state below

--[[
=== lua/mappings.lua (original state) ===
See git diff or backup for full content
Key differences: Missing toggle functions, harpoon, enhanced yank system

=== lua/plugins/init.lua (original state) ===
See git diff or backup for full content
Key differences: Missing bigfile, cloak, illuminate, lspsaga, rustaceanvim, session-manager

=== lua/autocmds.lua (original state) ===
No changes planned for this file in initial merge
--]]

-- FIX APPLIED 2026-02-13T23:15:30-07:00:
-- Fixed E1511 error in init.lua nvim-ufo config
-- Problem: Multi-byte Unicode characters in fold_virt_text_handler suffix and
--          preview border were causing "Wrong number of characters for field foldopen"
-- Solution: Replaced Unicode chars with ASCII equivalents:
--   - suffix: Changed "󰁂" to "..."
--   - border: Changed "─" to "-"
--
-- To restore previous state (will reintroduce the error):
--   In init.lua nvim-ufo config, change:
--     suffix = (" ... %d "):format(endLnum - lnum)
--   Back to:
--     suffix = (" 󰁂 %d "):format(endLnum - lnum)
--   And change border from "-" back to "─"

-- FIX APPLIED 2026-02-13T23:52:49-07:00:
-- Fixed Telescope ft_to_lang error using metatable proxy
-- Problem: vim.treesitter.language.ft_to_lang was removed in Neovim 0.10+
--          Previous shim attempts using rawset/timers/autocmds were not reliable
-- Solution: Use a metatable proxy on vim.treesitter.language that always
--          returns the shim function when "ft_to_lang" is accessed
-- See: lua/restore-points/2026-02-13-ft-to-lang-metatable-fix.lua

return {
  created = "2026-02-13T21:42:01-07:00",
  updated = "2026-02-13T23:52:49-07:00",
  description = "Pre-backup-merge restore point",
}
