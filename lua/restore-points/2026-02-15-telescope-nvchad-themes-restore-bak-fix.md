# Restore Point: Telescope NvChad Themes Fix (restore backup)

**Date:** 2026-02-15T12:23:37-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` resolves to the **NvChad themes picker**, not Telescope's builtin layout themes picker, when restoring from `lua/.restore/2026-02-13/plugins-init.lua.bak`.

## Problem Observed

In `lua/.restore/2026-02-13/plugins-init.lua.bak`, Telescope was configured to:

- load extensions without `pcall`, which can surface errors if an extension is unavailable
- not force `builtin.themes` to use the NvChad themes extension picker

Result, `:Telescope themes` could open Telescope's builtin layout themes picker instead of NvChad themes.

## Fix Applied

Updated `lua/.restore/2026-02-13/plugins-init.lua.bak` Telescope config block to:

- safely load base46 Telescope highlights via `pcall(dofile, vim.g.base46_cache .. "telescope")`
- load extensions via `pcall(telescope.load_extension, ext)` and also attempt `pcall(telescope.load_extension, "themes")`
- set `telescope.builtin.themes` to `telescope.extensions.themes.themes` when available
- fallback to `builtin.colorscheme` if the NvChad themes extension is not available

## Files Modified

- `lua/.restore/2026-02-13/plugins-init.lua.bak`

## How To Restore (revert this restore point)

```bash
git checkout HEAD~1 -- lua/.restore/2026-02-13/plugins-init.lua.bak
rm -f lua/restore-points/2026-02-15-telescope-nvchad-themes-restore-bak-fix.md
```

## Verification

After restoring from the `.bak` file and restarting Neovim:

- Run `:Telescope themes`
- Confirm:
  - no errors or warnings are printed
  - the picker shows NvChad theme names, not layout themes like dropdown or ivy
  - selecting a theme applies it successfully
