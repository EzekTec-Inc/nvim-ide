# Restore Point: Telescope NvChad Themes Picker opts forwarding fix

**Date:** 2026-02-15T12:51:56-07:00 (Sunday)

## Goal

Make `:Telescope themes` reliably invoke the NvChad themes picker, load cleanly, and avoid any errors or warnings.

## Problem

There were multiple entrypoints for the NvChad themes picker, and the wrapper functions used to redirect `:Telescope themes` were not forwarding the options table that Telescope passes to builtin pickers.

In practice, this can cause inaccurate behavior, such as picker options not being applied consistently depending on how the picker was invoked.

## Fix Applied

1. Updated `_G._nvchad_open_themes_picker` to accept an optional `opts` argument and forward it to:
   - `telescope.extensions.themes.themes(opts)` when available.
   - `telescope.builtin.colorscheme(opts)` as fallback.

2. Updated the Telescope builtin override wrappers in:
   - `init.lua`
   - `lua/plugins/init.lua`

   So `builtin.themes` forwards `opts` and prefers calling `_G._nvchad_open_themes_picker(opts)` when available.

## Files Modified

- `lua/chadrc.lua`
- `init.lua`
- `lua/plugins/init.lua`

## How To Restore

If you need to revert this change:

```bash
git checkout HEAD~1 -- lua/chadrc.lua init.lua lua/plugins/init.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad theme names.
   - Selecting a theme applies correctly.
