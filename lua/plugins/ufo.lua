-- RESTORE POINT: 2026-02-13T23:09:58-07:00
-- Updated: 2026-02-13T23:12:17-07:00
-- Updated: 2026-02-13T23:12:54-07:00
-- Updated: 2026-02-13T23:14:26-07:00
-- Fixed: E1511 error caused by foldopen/foldsep/foldclose in fillchars
-- These fields require single-byte ASCII characters only
-- Removed conflicting fillchars settings that were causing the error
-- This file is DISABLED - main ufo config is in init.lua to prevent duplicates
--
-- FIX 2026-02-13T23:14:26: Also removed multi-byte Unicode chars from:
--   - fold_virt_text_handler suffix (replaced 󰁂 with ...)
--   - preview border chars (replaced ─ with -)
-- These were causing E1511 when nvim tried to parse them for fillchars

-- Return empty table to disable this plugin file
-- All nvim-ufo configuration is handled in init.lua
return {}
