# Restore Point: ft_to_lang rawset Fix

**Date:** 2026-02-13T23:58:49-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The metatable proxy for `vim.treesitter.language` was correctly intercepting access via the `__index` metamethod, but the `ft_to_lang` function was not stored directly in the proxy table itself. When Telescope previewers accessed `vim.treesitter.language.ft_to_lang`, Lua's table lookup found `nil` in the table before falling back to `__index` in some execution contexts.

## Fix Applied

Added `rawset(_language_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)` after creating the proxy table to store the function directly in the table. This ensures the function is accessible via both:
1. Direct table access (`rawget` or normal indexing)
2. Metatable `__index` fallback

Also updated `_ensure_ft_to_lang_shim()` to always re-apply the rawset, ensuring the function persists even if something attempts to remove it.

## Files Modified

- `init.lua` - Added rawset calls for ft_to_lang in proxy table and ensure function

## To Restore Previous State

In `init.lua`, remove the two rawset lines:

```lua
-- Remove this line after proxy creation:
rawset(_language_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)

-- Remove this line from _ensure_ft_to_lang_shim function:
rawset(_language_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The ft_to_lang error should no longer appear
