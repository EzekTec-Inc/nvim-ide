# Restore Point: Telescope NvChad Themes Silent Fix

**Date:** 2026-02-15T13:23:55-07:00 (Sunday)

## Goal

Make the NvChad theme picker entrypoints (`:Telescope themes`, dashboard Themes button, and related wrappers) load cleanly with no errors or warnings, behave consistently, and keep the UI looking correct.

## Changes Applied

1. **Avoid noisy extension loading**
   - Guarded `telescope.load_extension("themes")` behind a safe `pcall(require, "telescope._extensions.themes")` so Neovim does not emit extension load warnings when the extension is not available at that moment.

2. **Ensure Telescope highlight styling is present when opening the picker**
   - The themes picker wrappers now try to load Base46 Telescope highlights (`dofile(vim.g.base46_cache .. "telescope")`) before invoking the picker, so the UI renders consistently even when opened from non-standard entrypoints.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`
- `lua/chadrc.lua`

## How To Restore

Use git to revert the last commit that introduced this restore point:

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua lua/chadrc.lua
```

Then restart Neovim.

## Verification Checklist

- Restart Neovim
- Run `:Telescope themes`
- Confirm:
  - no errors or warnings are printed
  - the picker opens reliably
  - the UI looks correct (Base46 Telescope highlights applied)
  - selecting a theme applies it as expected
