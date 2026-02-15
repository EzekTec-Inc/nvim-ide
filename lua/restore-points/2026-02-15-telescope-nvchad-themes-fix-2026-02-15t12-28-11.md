# Restore Point: Telescope NvChad Themes Reliability Fix

**Date:** 2026-02-15T12:28:11-07:00 (Sunday)

## Goal

Make `:Telescope themes` reliably open the **NvChad themes picker** when available, without errors or warnings, and without adding bloat.

## Problem Observed

Depending on load order and whether the NvChad `themes` extension is available at the exact moment `:Telescope themes` is invoked, Telescope can fall back to its builtin picker behavior rather than the NvChad themes picker.

## Fix Applied

Updated the Telescope config blocks to set `telescope.builtin.themes` to a small wrapper function that:

- Always attempts to `load_extension("themes")` at call time (safe via `pcall`).
- Uses `telescope.extensions.themes.themes` when available.
- Falls back to `telescope.builtin.colorscheme` if the NvChad themes picker is not available.

This keeps behavior correct when the NvChad themes extension is present, and prevents errors when it is not.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## How To Restore

To revert to the previous state:

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - If NvChad themes extension is available, you see NvChad theme names.
   - Selecting a theme applies cleanly.
