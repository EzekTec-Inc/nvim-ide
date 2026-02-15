# Restore Point: Telescope ft_to_lang Metatable Fix

**Date:** 2026-02-13T23:43:34-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+, but Telescope's previewer still references it. Previous shim attempts using `rawset` were being overwritten when the treesitter module was reloaded or replaced by lazy-loaded plugins.

## Fix Applied

Changed the shim approach in `init.lua` from using `rawset` to using a **metatable proxy** on `vim.treesitter.language`. The metatable:

1. Intercepts all `__index` lookups for `ft_to_lang` and returns our shim function
2. Intercepts `__newindex` to prevent `ft_to_lang` from being set to `nil`
3. Passes through all other table operations to the original language table

This ensures `ft_to_lang` is **always** available regardless of module reloads or table replacements.

## Files Modified

- `init.lua` - Changed ft_to_lang shim from rawset approach to metatable proxy approach

## To Restore Previous State

If this fix causes issues, revert the shim block in `init.lua` to the previous version:

```lua
-- Replace the metatable proxy block with:
_G._apply_ft_to_lang_shim = function()
  if not vim.treesitter then
    vim.treesitter = {}
  end
  if not vim.treesitter.language then
    vim.treesitter.language = {}
  end
  rawset(vim.treesitter.language, "ft_to_lang", _G._treesitter_ft_to_lang)
end

_G._apply_ft_to_lang_shim()
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
