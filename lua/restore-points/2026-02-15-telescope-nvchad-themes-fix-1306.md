# Restore Point: Telescope NvChad Themes Picker Hardening

**Date:** 2026-02-15T13:06:43-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker, triggered via `:Telescope themes` and NvChad UI entrypoints, loads without errors or warnings, routes to the correct picker reliably, and stays minimal.

## Problem Observed

The NvChad themes picker routing could fail or behave inconsistently depending on how the `themes` extension exports its callable entrypoint, and depending on timing and error paths.

## Fix Applied

1. **Harden the themes picker call shape**
   - Support both patterns safely:
     - `telescope.extensions.themes.themes(opts)` when the extension exports a table
     - `telescope.extensions.themes(opts)` when the extension itself is callable
   - All calls are `pcall` wrapped, and `opts` is normalized to `{}`.

2. **Keep routing centralized and safe**
   - `lua/chadrc.lua`: `_G._nvchad_open_themes_picker(opts)` now normalizes opts and safely calls the picker.
   - `init.lua` and `lua/plugins/init.lua`: wrappers now `pcall` `_G._nvchad_open_themes_picker` and use the same safe call logic for fallbacks.

## Files Modified

- `lua/chadrc.lua`
- `init.lua`
- `lua/plugins/init.lua`

## To Restore Previous State

Use git to revert the last change:

```bash
git checkout HEAD~1 -- lua/chadrc.lua init.lua lua/plugins/init.lua
```

Then restart Neovim and try:

- `:Telescope themes`

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - no errors or warnings are printed
   - the picker opens and selecting a theme applies cleanly
   - dashboard theme button and `<leader>th` still work as expected
