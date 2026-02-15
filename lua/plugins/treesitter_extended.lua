-- RESTORE POINT: 2026-02-13T22:08:36-07:00
-- Fixed: nvim-treesitter 1.0+ removed the 'nvim-treesitter.configs' module.
-- This file previously caused errors by trying to require that module.
--
-- Previous error: module 'nvim-treesitter.configs' not found
--
-- All treesitter configuration is now handled in lua/plugins/treesitter.lua
-- This file returns an empty table to prevent any plugin loading issues.
--
-- DO NOT add any config function or require statements for nvim-treesitter.configs to this file.

-- Empty return - all treesitter config is in treesitter.lua
return {}
