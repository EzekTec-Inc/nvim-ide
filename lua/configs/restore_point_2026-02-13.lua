-- RESTORE POINT: 2026-02-13T21:51:20-07:00 (Friday)
-- This file documents the state before adding missing plugins from nvim-jan-2026-working.bak
--
-- To restore, revert the following files to their state before this date:
--   - lua/plugins/init.lua
--   - lua/mappings.lua
--   - lua/configs/utils.lua (if created)
--
-- Changes made:
--   1. Added missing plugins: bigfile, cloak, illuminate, inlay-hints, legendary,
--      duplicate, lspsaga, rustaceanvim, neovim-session-manager
--   2. Enhanced treesitter config with textobjects, context-commentstring, autotag
--   3. Enhanced ufo config with custom fold handler
--   4. Created lua/configs/utils.lua for utility functions
--
-- Git command to restore (if committed):
--   git checkout HEAD~1 -- lua/plugins/init.lua lua/mappings.lua lua/configs/utils.lua

return {
  restore_date = "2026-02-13T21:51:20-07:00",
  description = "Before adding missing plugins from nvim-jan-2026-working.bak"
}
