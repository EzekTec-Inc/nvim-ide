# Restore Point: Telescope NvChad Themes LazyLoad Hook Fix

**Date:** 2026-02-15T13:09:31-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` routes to the NvChad theme picker reliably even when Telescope is loaded later via lazy-loading, and ensure the Treesitter `ft_to_lang` shim is re-applied whenever Telescope loads to avoid preview related errors.

## Problem Observed

The shim application and the `builtin.themes` routing can be applied before Telescope is actually loaded. When Telescope loads later, it can end up using the default Telescope builtin `themes` picker (layout themes) or run without the expected shims applied at that moment.

## Fix Applied

Updated `init.lua` to add an additional autocmd hook:

- `User LazyLoad` autocmd calls `_apply_nvchad_themes_and_ft_to_lang_shims`

This causes the shims and theme routing to be re-applied whenever lazy.nvim loads plugins, including when `telescope.nvim` is loaded after startup.

## Files Modified

- `init.lua`

## To Restore Previous State

In `init.lua`, remove this block:

```lua
-- FIX 2026-02-15T13:09:31-07:00: Re-apply shims on LazyLoad to cover lazy-loaded Telescope.

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})
```

Then restart Neovim.

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - no errors or warnings are printed
   - the picker shows NvChad theme names (not Telescope layout themes like dropdown/ivy)
   - selecting a theme applies it cleanly
