# Restore Point: Telescope NvChad Themes Accuracy Fix

**Date:** 2026-02-15T13:11:32-07:00 (Sunday)

## Goal

Make `:Telescope themes` consistently open the **NvChad themes picker** (not Telescope layout themes, and not a generic colorscheme fallback), without errors or warnings, and without adding bloat.

## What Changed

- `init.lua`
  - Simplified the `telescope.builtin.themes` override to route through `_G._nvchad_open_themes_picker` (defined in `lua/chadrc.lua`), with a small safety `pcall(require, "chadrc")` if it is not yet defined.
  - Removed the duplicate per-plugin `nvchad_themes_picker` wrapper inside the Telescope plugin config, so there is only one routing path.

- `lua/plugins/init.lua`
  - Removed the duplicate per-plugin `nvchad_themes_picker` wrapper and the extra scheduled reassignment.
  - Kept a single call to `_G._apply_telescope_nvchad_themes_picker()` so the entrypoint is unified.

## Why

Multiple slightly different wrappers and reassignment paths made the behavior inconsistent depending on load order, and could silently fall back to a non-NvChad picker even when the NvChad picker was available.

This change consolidates the routing so the picker source is consistent and minimal.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## How To Restore

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - no errors or warnings are printed
   - the picker shows NvChad themes
   - selecting a theme applies it correctly
