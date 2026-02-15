# Restore Point: ft_to_lang Final Fix

**Date:** 2026-02-13T23:48:43-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+, but Telescope's previewer utils still call it. The previous shim attempts were being overwritten during plugin loading.

## Fix Applied

Enhanced the shim in `init.lua` to use a metatable-based approach that prevents the function from being overwritten. The metatable intercepts any attempts to set `ft_to_lang` to nil or to overwrite the entire `vim.treesitter.language` table.

Key changes:
1. Applied metatable to `vim.treesitter.language` that always returns the shim for `ft_to_lang`
2. Added protection against the table being replaced entirely
3. Ensured the shim is applied at multiple points during initialization

## To Restore Previous State

```lua
-- In init.lua, remove the metatable-based protection and revert to:
vim.treesitter.language.ft_to_lang = ft_to_lang_shim
```

Or use git:
```bash
git checkout HEAD~1 -- init.lua
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any telescope command
3. The ft_to_lang error should no longer appear
