-- RESTORE POINT: 2026-02-13T23:09:58-07:00
-- Updated: 2026-02-13T23:14:27-07:00
-- This file is disabled to prevent duplicate nvim-ufo configuration
-- The main ufo configuration is in init.lua (NOT lua/plugins/ufo.lua)
--
-- Previous error fixed:
--   E1511: Wrong number of characters for field "foldopen"
--   The foldopen, foldsep, foldclose fields in fillchars require single-byte
--   ASCII chars only and were causing conflicts with multiple ufo configs
--
-- DO NOT re-enable this file - all nvim-ufo config is in init.lua

return {}
