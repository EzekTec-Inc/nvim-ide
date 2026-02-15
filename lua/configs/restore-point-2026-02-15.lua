-- RESTORE POINT: 2026-02-15T12:41:22-07:00 (Sunday)
-- This file documents the state before fixing the NvChad Telescope themes picker entrypoint.
--
-- To restore, revert the following files to their state before this date:
--   - lua/chadrc.lua
--   - lua/mappings.lua
--
-- Changes made:
--   1. lua/chadrc.lua: _G._nvchad_open_themes_picker now ensures telescope is loaded via lazy
--      before calling the NvChad `themes` extension, avoiding the Telescope builtin `themes` picker.
--   2. lua/mappings.lua: <leader>th now calls _G._nvchad_open_themes_picker() for consistent behavior.
--
-- Git command to restore (if committed):
--   git checkout HEAD~1 -- lua/chadrc.lua lua/mappings.lua

return {
  restore_date = "2026-02-15T12:41:22-07:00",
  description = "Before fixing NvChad Telescope themes picker entrypoint",
}
