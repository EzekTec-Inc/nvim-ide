-- RESTORE POINT: 2026-02-17T22:36:47-07:00 (Tuesday)
-- This file documents the state before fixing clipboard yank/paste mappings.
--
-- Issue addressed:
--   lua/mappings.lua remapped y/Y/yy and p/P to the "0 register.
--   This prevented normal yanks and puts from integrating with the system clipboard
--   (even though clipboard=unnamedplus is enabled in lua/options.lua).
--
-- Fix applied:
--   - lua/mappings.lua: y/Y/yy and p/P now use the default behavior again, so
--     clipboard=unnamedplus can provide system clipboard integration.
--
-- How to restore:
--   git checkout HEAD~1 -- lua/mappings.lua lua/configs/restore-point-2026-02-17-22-36-47.lua

return {
  restore_date = "2026-02-17T22:36:47-07:00",
  description = "Before fixing yank/paste mappings to allow system clipboard integration via clipboard=unnamedplus",
}
