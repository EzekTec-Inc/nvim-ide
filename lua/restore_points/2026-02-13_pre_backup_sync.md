# Restore Point: 2026-02-13 Pre-Backup Sync

## Latest Fix Applied

**2026-02-13T23:56:05-07:00:** Fixed Telescope ft_to_lang error "attempt to call field 'ft_to_lang' (a nil value)"

The error occurred because the metatable proxy approach for the ft_to_lang shim wasn't working correctly. The proxy table was empty and Telescope's direct table access returned nil. Fixed by using simple direct assignment instead of metatable proxy, with VimEnter autocmd as additional safety net.

To restore previous (metatable proxy) state, see `lua/restore_points/2026-02-13_ft_to_lang_simple_fix.md`.

---

**2026-02-13T23:16:52-07:00:** Fixed E1511 error "Wrong number of characters for field foldopen"

The error was caused by Neovim validating fillchars when foldcolumn was enabled. The fix:
1. Changed `lua/options.lua` to use string format `vim.o.fillchars` instead of table format `vim.opt.fillchars`
2. Added `vim.o.foldcolumn = "0"` in `init.lua` nvim-ufo config to disable foldcolumn (nvim-ufo uses virtual text instead)

To restore previous state:
```lua
-- In lua/options.lua, change:
vim.o.fillchars = "eob: ,fold: "
-- Back to:
vim.opt.fillchars = { eob = " ", fold = " " }

-- In init.lua nvim-ufo config, remove:
vim.o.foldcolumn = "0"
```

---

**2026-02-13T22:08:20-07:00:** Fixed `lua/plugins/treesitter_extended.lua` which was causing the error:
```
module 'nvim-treesitter.configs' not found
```

The file was attempting to require `nvim-treesitter.configs` which no longer exists in nvim-treesitter 1.0+. The file now returns an empty table, as all treesitter configuration is handled in `lua/plugins/treesitter.lua`.

## Changes Made
This restore point documents the state before syncing plugins and configurations from the backup at `~/.config/nvim-jan-2026-working.bak/`.

## Files Created
- `lua/configs/utils.lua` - Utility functions for mappings
- `lua/plugins/bigfile.lua` - Large file handling
- `lua/plugins/cloak.lua` - Sensitive data hiding
- `lua/plugins/illuminate.lua` - Word highlighting
- `lua/plugins/inlayhints.lua` - LSP inlay hints
- `lua/plugins/legendary.lua` - Keymapping management
- `lua/plugins/lspsaga.lua` - Enhanced LSP UI
- `lua/plugins/rustaceanvim.lua` - Rust support
- `lua/plugins/sessions.lua` - Session management
- `lua/plugins/treesitter.lua` - Treesitter configuration
- `lua/plugins/ufo.lua` - Code folding

## Files Modified
- `lua/plugins/init.lua` - Removed duplicate plugin definitions that are now in separate files

## To Restore
To restore to the pre-sync state, delete the created files listed above and restore `lua/plugins/init.lua` from git:

```bash
# Remove created files
rm -f lua/configs/utils.lua
rm -f lua/plugins/bigfile.lua
rm -f lua/plugins/cloak.lua
rm -f lua/plugins/illuminate.lua
rm -f lua/plugins/inlayhints.lua
rm -f lua/plugins/legendary.lua
rm -f lua/plugins/lspsaga.lua
rm -f lua/plugins/rustaceanvim.lua
rm -f lua/plugins/sessions.lua
rm -f lua/plugins/treesitter.lua
rm -f lua/plugins/ufo.lua
rm -rf lua/restore_points

# Restore init.lua from git
git checkout lua/plugins/init.lua
```
