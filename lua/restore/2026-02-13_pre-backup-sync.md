# Restore Point: Pre-Backup Sync

**Date:** 2026-02-13T21:49:45-07:00 (Friday)
**Updated:** 2026-02-13T23:15:55-07:00 (Friday)

## Purpose

This restore point documents the state before syncing plugins and mappings from `~/.config/nvim-jan-2026-working.bak/`.

## Latest Fix Applied

**2026-02-13T23:54:09-07:00:** Fixed Telescope ft_to_lang error "attempt to call field 'ft_to_lang' (a nil value)"

The error occurred because `vim.treesitter.language.ft_to_lang` was removed in Neovim 0.10+ but Telescope previewers still reference it. The previous simple shim could be overwritten by lazy-loaded modules.

The fix uses a metatable proxy approach:
1. Created a proxy table with `__index` metamethod that always returns the shim function
2. Added `__newindex` protection to prevent nil overwrites
3. Added multiple autocmds as safety nets to re-apply the proxy if the table gets replaced

To restore previous state:
```lua
-- In init.lua, replace the metatable proxy block with simple assignment:
vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim
```

See `lua/restore_points/2026-02-13_ft_to_lang_proxy_fix.md` for full details.

---

**2026-02-13T23:15:55-07:00:** Fixed E1511 error "Wrong number of characters for field foldopen"

The error was caused by fillchars validation in Neovim. The fix:
1. Updated `lua/options.lua` to explicitly set all fold-related fillchars with valid single-byte ASCII characters (empty strings for foldopen/foldclose)
2. Updated `init.lua` nvim-ufo config to set `foldcolumn = "1"` and added `provider_selector` for proper fold provider configuration

To restore previous state before this fix:
```lua
-- In lua/options.lua, change fillchars back to:
opt.fillchars = { eob = " ", fold = " " }

-- In init.lua nvim-ufo config, remove:
-- vim.o.foldcolumn = "1"
-- provider_selector function
```

**2026-02-13T22:07:48-07:00:** Fixed `lua/plugins/treesitter_extended.lua` which was causing the error:
```
module 'nvim-treesitter.configs' not found
```

The file was attempting to require `nvim-treesitter.configs` which no longer exists in nvim-treesitter 1.0+. The file now returns an empty table, as all treesitter configuration is handled in `lua/plugins/treesitter.lua`.

## Files Modified

- lua/plugins/init.lua
- lua/mappings.lua
- lua/configs/lsp.lua
- lua/plugins/treesitter_extended.lua (fixed 2026-02-13T22:07:48)

## Files Added

- lua/plugins/bigfile.lua
- lua/plugins/cloak.lua
- lua/plugins/illuminate.lua
- lua/plugins/inlayhints.lua
- lua/plugins/legendary.lua
- lua/plugins/lsp_progress_nvim.lua
- lua/plugins/lspkind_nvim.lua
- lua/plugins/lspsaga.lua
- lua/plugins/rustaceanvim.lua
- lua/plugins/sessions.lua
- lua/plugins/ufo.lua
- lua/configs/utils.lua

## To Restore

To revert these changes, delete the added files and restore the modified files from git:

```bash
# Remove added files
rm -f lua/plugins/bigfile.lua
rm -f lua/plugins/cloak.lua
rm -f lua/plugins/illuminate.lua
rm -f lua/plugins/inlayhints.lua
rm -f lua/plugins/legendary.lua
rm -f lua/plugins/lsp_progress_nvim.lua
rm -f lua/plugins/lspkind_nvim.lua
rm -f lua/plugins/lspsaga.lua
rm -f lua/plugins/rustaceanvim.lua
rm -f lua/plugins/sessions.lua
rm -f lua/plugins/ufo.lua
rm -f lua/configs/utils.lua
rm -rf lua/restore/

# Restore modified files
git checkout lua/plugins/init.lua
git checkout lua/mappings.lua
git checkout lua/configs/lsp.lua
git checkout lua/plugins/treesitter_extended.lua
```
