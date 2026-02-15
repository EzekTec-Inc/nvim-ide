# Restore Point: ft_to_lang Metatable Fix

**Date:** 2026-02-13T23:53:00-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The previous fix using timers and autocmds to re-apply the `ft_to_lang` shim was not reliable. The shim was being overwritten or not persisting when Telescope's previewer accessed `vim.treesitter.language.ft_to_lang`.

The issue occurs because:
1. `vim.treesitter.language.ft_to_lang` was removed in Neovim 0.10+
2. Telescope's previewers still reference this function
3. Previous approaches to patch the function were not surviving module reloads

## Fix Applied

Changed the approach from timer-based re-application to a metatable proxy pattern:

1. Created a proxy table for `vim.treesitter.language` using `setmetatable`
2. The `__index` metamethod always returns our shim function when `ft_to_lang` is accessed
3. The `__newindex` metamethod prevents `ft_to_lang` from being set to `nil`
4. Also set `ft_to_lang` directly via `rawset` for code that uses `rawget`

This ensures that no matter how `ft_to_lang` is accessed (normal indexing or rawget), it will always return a valid function.

## Files Modified

- `init.lua` - Changed ft_to_lang shim implementation to use metatable proxy

## To Restore Previous State

If you need to revert to the previous timer-based approach:

```lua
-- In init.lua, replace the metatable proxy do...end block with the previous
-- timer and autocmd based approach from the previous commit
```

Or use git:
```bash
git checkout HEAD~1 -- init.lua
```

## Verification

After applying this fix:
1. Restart Neovim
2. Open Telescope with `:Telescope themes` or `:Telescope find_files`
3. The ft_to_lang error should no longer appear
4. File previews should work correctly
