-- This file intentionally left empty.-- This file shadows the nvim-lspconfig plugin module.
-- Return the actual plugin module to avoid breaking requires.
-- Consider deleting this file entirely: rm ~/.config/nvim/lua/lspconfig.lua
return require("lspconfig.configs") and require("lspconfig") or {}-- Note: Do not name files "lspconfig.lua" at the lua/ root level as it shadows
-- the nvim-lspconfig plugin module. Configuration is in lua/configs/lspconfig.lua