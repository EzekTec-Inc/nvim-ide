# Restore Point: ft_to_lang Telescope Fix

**Date:** 2026-02-13T23:52:14-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+. The previous shim implementation was being overwritten or cleared by lazy.nvim during plugin loading, causing Telescope's previewer to fail when trying to call the function.

## Fix Applied

Enhanced the ft_to_lang shim in `init.lua` with:

1. A timer-based approach that re-applies the shim every 50ms for the first second of startup
2. The `ensure_ft_to_lang()` function that checks and re-applies the shim if it's missing
3. Multiple autocmd hooks (VimEnter, BufReadPre, FileType, User) to catch various loading stages
4. Both direct assignment and rawset to ensure the shim is set at all table levels

## Files Modified

- `init.lua` - Enhanced ft_to_lang shim implementation

## To Restore Previous State

If this fix causes issues, revert the shim section in `init.lua` to the previous version:

```lua
-- In init.lua, replace the ft_to_lang shim do...end block with the previous version
-- that used metatable __index fallback approach
```

Or use git:
```bash
git checkout HEAD~1 -- init.lua
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The ft_to_lang error should no longer appear
