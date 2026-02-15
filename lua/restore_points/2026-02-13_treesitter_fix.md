# Restore Point: Treesitter Extended Fix

**Date:** 2026-02-13T22:08:36-07:00 (Friday)
**Updated:** 2026-02-13T23:17:35-07:00 (Friday)

## Issue Fixed

Error: `module 'nvim-treesitter.configs' not found`

The `lua/plugins/treesitter_extended.lua` file was attempting to require `nvim-treesitter.configs` which no longer exists in nvim-treesitter 1.0+.

## Files Modified

1. `lua/plugins/treesitter_extended.lua` - Removed config function, now returns empty table
2. `lua/plugins/treesitter.lua` - Fixed config function to not use deprecated configs module, simplified textobjects dependency

## Latest Fix Applied

**2026-02-13T23:57:21-07:00:** Fixed Telescope ft_to_lang error "attempt to call field 'ft_to_lang' (a nil value)"

The metatable proxy approach was missing a `rawset` call to actually store the shim function in the proxy table. Without this, direct table access (like `vim.treesitter.language.ft_to_lang`) could return `nil` because the proxy table was empty and only the `__index` metamethod would return the function.

**Fix:** Added `rawset(_ts_lang_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)` after creating the proxy table to ensure the function is accessible via both direct table access and metamethod access.

**To restore previous state:**
```lua
-- In init.lua, remove the rawset line:
rawset(_ts_lang_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)
```

---

**2026-02-13T23:17:35-07:00:** Fixed E1511 error "Wrong number of characters for field foldopen"

The error was caused by Neovim attempting to use fillchars for foldopen/foldclose when foldcolumn was potentially non-zero at some point during initialization.

**Fix:**
1. In `init.lua` nvim-ufo init function: Added `vim.o.fillchars = "eob: ,fold: "` to ensure fillchars is set before any fold operations
2. In `lua/options.lua`: Added `vim.o.foldcolumn = "0"` to ensure foldcolumn is disabled early

**To restore previous state:**
```lua
-- In init.lua nvim-ufo init function, remove:
vim.o.fillchars = "eob: ,fold: "

-- In lua/options.lua, remove:
vim.o.foldcolumn = "0"
```

## To Restore Treesitter Changes

If you need to revert these changes:

```bash
git checkout HEAD~1 -- lua/plugins/treesitter_extended.lua lua/plugins/treesitter.lua
```

Or manually restore the files from git history.

## Technical Details

nvim-treesitter 1.0+ made breaking changes:
- Removed `nvim-treesitter.configs` module entirely
- Highlighting is now automatic when parsers are installed
- Configuration is handled via `vim.treesitter` APIs directly

nvim-ufo E1511 error:
- Neovim validates fillchars fields when foldcolumn is enabled
- foldopen, foldsep, foldclose require exactly one single-byte ASCII character
- Empty strings or multi-byte Unicode characters cause E1511
- Solution: Set foldcolumn to "0" and only use valid fillchars fields (eob, fold)
