# Restore Point: Telescope NvChad Themes Stability Fix

**Date:** 2026-02-15T13:16:16-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` and the NvChad dashboard theme picker load the NvChad theme list reliably, without errors or warnings, and without adding bloat.

## Changes Applied

1. `init.lua`
   - Updated `_apply_telescope_nvchad_themes_picker()` to prefer the NvChad Telescope `themes` extension when available.
   - When the extension picker is available, `telescope.builtin.themes` is set to a small wrapper that applies the `ft_to_lang` shim and then calls the extension picker.
   - Falls back to the existing `_G._nvchad_open_themes_picker` approach if the extension picker is unavailable.

2. `lua/chadrc.lua`
   - Removed a potential recursion path by changing the fallback command (only used if Telescope cannot be required) from `Telescope themes` to `Telescope colorscheme`.

## Files Modified

- `init.lua`
- `lua/chadrc.lua`

## To Restore Previous State

```bash
git checkout HEAD~1 -- init.lua lua/chadrc.lua
```

## Verification Steps

1. Restart Neovim.
2. Run `:Telescope themes`.
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad theme names.
   - Selecting a theme applies it.
