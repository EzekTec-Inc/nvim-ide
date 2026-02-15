# Restore Point: Treesitter Textobjects Fix

**Date:** 2026-02-13T22:07:02-07:00 (Friday)
**Updated:** 2026-02-13T23:18:02-07:00 (Friday)

## Issue Fixed

Error: `Failed to run config for nvim-treesitter-textobjects`
Cause: `module 'nvim-treesitter.configs' not found`

The nvim-treesitter 1.0+ version removed the `nvim-treesitter.configs` module.
The textobjects plugin dependency was trying to use this removed module.

## Files Modified

1. `lua/plugins/treesitter.lua` - Updated to handle nvim-treesitter 1.0+ compatibility
   - Added explicit config function for nvim-treesitter-textobjects dependency
   - Updated main config to try legacy module first, then fall back to 1.0+ approach

2. `lua/plugins/treesitter_extended.lua` - Confirmed empty (no changes needed)
   - File already returns empty table

## Additional Fix Applied 2026-02-13T23:18:02

Fixed E1511 error "Wrong number of characters for field foldopen" in nvim-ufo:

**Problem:** The `lua/options.lua` file was setting `foldopen`, `foldclose`, and `foldsep` in `vim.opt.fillchars`. These fields are validated at parse time, before nvim-ufo's init function can set `foldcolumn = "0"` to disable validation.

**Solution:** Removed `foldopen`, `foldclose`, and `foldsep` from `vim.opt.fillchars` in `lua/options.lua`. nvim-ufo handles fold display via `fold_virt_text_handler`, not the fold column, so these fillchars are not needed.

**File Modified:** `lua/options.lua`

**To restore previous state:**
```lua
-- In lua/options.lua, change:
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
}
-- Back to:
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "-",
  foldclose = "+",
  foldsep = " ",
}
```

## How to Restore

If issues persist, you can revert by restoring the previous treesitter.lua:

```bash
git checkout HEAD~1 -- lua/plugins/treesitter.lua
```

Or delete the textobjects dependency temporarily:

```lua
-- In lua/plugins/treesitter.lua, comment out:
-- "nvim-treesitter/nvim-treesitter-textobjects",
```
