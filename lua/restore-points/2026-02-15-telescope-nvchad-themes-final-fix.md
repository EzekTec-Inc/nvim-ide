# Restore Point: Telescope NvChad Themes Final Fix

**Date:** 2026-02-15T12:52:00-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` and the NvChad dashboard Themes button open the NvChad theme picker reliably, with no errors or warnings, and without adding bloat.

## Issue Observed

The NvChad themes picker can fail to open correctly when the themes extension is present but exposed in a different callable shape, for example:

- `telescope.extensions.themes` is a function, not a table
- `telescope.extensions.themes.themes` is the function (older or different layout)

This caused the picker to silently fall back to `builtin.colorscheme` in some cases, which is not the NvChad theme picker.

## Fix Applied

- `lua/chadrc.lua`
  - Hardened `_G._nvchad_open_themes_picker()` to support both callable shapes:
    - `telescope.extensions.themes()` and
    - `telescope.extensions.themes.themes()`
  - Keeps fallback to `builtin.colorscheme()` if the themes extension is not available.

- `init.lua` and `lua/plugins/init.lua`
  - Ensured `telescope.builtin.themes` routes through `_G._nvchad_open_themes_picker` (loading `chadrc` if needed), so `:Telescope themes` consistently opens the NvChad picker.

## Files Modified

- `lua/chadrc.lua`
- `init.lua`
- `lua/plugins/init.lua`

## How To Restore

Use git to revert the last change:

```bash
git checkout HEAD~1 -- lua/chadrc.lua init.lua lua/plugins/init.lua
```

Then restart Neovim.

## Verification Checklist

- Restart Neovim.
- Run `:Telescope themes`
- Confirm:
  - no errors or warnings are printed
  - the picker shows NvChad themes, not Telescope layout themes
  - selecting a theme applies it immediately
