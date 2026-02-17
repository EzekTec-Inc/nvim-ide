-- RESTORE POINT: 2026-02-17T13:18:55-07:00 (Tuesday)
-- This file documents the state before enforcing core LSP keymaps via an early LspAttach autocmd.
--
-- Change summary:
-- 1) init.lua: Added a UserCoreLspKeymaps LspAttach autocmd that re applies buffer local mappings for gD, gd, K, and gK.
-- 2) lua/configs/lspconfig.lua: Added missing K and gK mappings in M.on_attach for completeness.
--
-- How to restore:
-- git checkout HEAD~1 -- init.lua lua/configs/lspconfig.lua lua/configs/restore-point-2026-02-17-13-18-55.lua
--
-- How to verify:
-- In a buffer with an attached LSP client, run:
--   :verbose nmap <buffer> gD
--   :verbose nmap <buffer> gd
--   :verbose nmap <buffer> K
--   :verbose nmap <buffer> gK
-- They should report that the mapping was last set from init.lua.

return {
  restore_date = "2026-02-17T13:18:55-07:00",
  description = "Before enforcing core LSP keymaps (gD, gd, K, gK) via early LspAttach autocmd",
}
