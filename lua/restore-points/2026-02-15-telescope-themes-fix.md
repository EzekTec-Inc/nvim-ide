# Restore Point: Telescope NvChad Themes Fix

**Date:** 2026-02-15T12:13:15-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` (NvChad theme picker) loads without errors or warnings, works reliably, and looks correct without adding bloat.

## Changes Applied

### 1. Make NvChad theme metadata available in config

Updated `lua/chadrc.lua`:

- Added `ui.theme = "kanagawa"`
- Added `ui.theme_toggle = { "catppuccin", "catppuccin_light" }`

This keeps `ui.theme` in sync with the selected NvChad theme so any NvChad theme tooling that reads `nvconfig.ui.theme` can behave correctly.

### 2. Make Telescope extension loading more robust, and ensure `themes` is loadable

Updated `init.lua` and `lua/plugins/init.lua` Telescope config blocks:

- Safely load base46 Telescope highlights via `pcall(dofile, vim.g.base46_cache .. "telescope")`
- Load extensions using `pcall(telescope.load_extension, ext)` to prevent startup errors if an extension is temporarily unavailable
- Always attempt `pcall(telescope.load_extension, "themes")` so the NvChad themes picker is available when `:Telescope themes` is invoked
- Provide `telescope.builtin.themes` alias when the themes picker exists, with a fallback to `builtin.colorscheme` (only if themes picker is not available)

## Files Modified

- `lua/chadrc.lua`
- `init.lua`
- `lua/plugins/init.lua`

## How To Restore

To revert to the previous state:

```bash
git checkout HEAD~1 -- lua/chadrc.lua init.lua lua/plugins/init.lua
```

Then restart Neovim and try:

- `:Telescope themes`

## Verification Checklist

- Restart Neovim
- Run `:Telescope themes`
- Confirm:
  - no errors or warnings are printed
  - the picker opens and renders correctly
  - selecting a theme applies the theme as expected
