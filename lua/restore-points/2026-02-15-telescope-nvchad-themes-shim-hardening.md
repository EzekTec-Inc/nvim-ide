# Restore Point: Telescope NvChad Themes Shim Hardening

**Date:** 2026-02-15T13:24:08-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` (NvChad theme picker) loads reliably without errors or warnings, by hardening the early `ft_to_lang` compatibility shim used by Telescope preview code paths.

## Change Applied

- `init.lua`: Hardened `_apply_ft_to_lang_shim()` to ensure `vim.treesitter` and `vim.treesitter.language` exist as tables by assigning the module returned by `require(...)` when needed, then `rawset` the `ft_to_lang` shim.

## Files Modified

- `init.lua`

## How To Restore

```bash
git checkout HEAD~1 -- init.lua
```

## Verification

1. Restart Neovim.
2. Run `:Telescope themes`.
3. Confirm:
   - No errors or warnings are printed.
   - The picker opens and applies themes normally.
