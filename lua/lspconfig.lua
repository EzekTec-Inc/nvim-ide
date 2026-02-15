-- WARNING: This file exists only to prevent errors from existing requires.
-- It shadows the nvim-lspconfig plugin module which can cause issues.
-- 
-- RECOMMENDED: Delete this file entirely with:
--   rm ~/.config/nvim/lua/lspconfig.lua
--
-- All LSP configuration should be in lua/configs/lspconfig.lua or lua/configs/lsp.lua
--
-- RESTORE POINT: 2026-02-13T23:41:21-07:00
-- This file was reviewed but no changes were needed for the ft_to_lang fix.
-- The ft_to_lang error is fixed in init.lua, not here.

-- Attempt to return the actual lspconfig module from lazy.nvim
local ok, lspconfig = pcall(require, "lspconfig.configs")
if ok then
  return require("lspconfig")
end

return {}
