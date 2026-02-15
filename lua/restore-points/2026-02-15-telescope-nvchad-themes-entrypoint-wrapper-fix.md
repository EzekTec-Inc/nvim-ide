# Restore Point: Telescope NvChad Themes Entrypoint Wrapper Fix

**Date:** 2026-02-15T12:48:11-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` consistently opens the **NvChad themes picker** (not Telescope's builtin layout themes picker), loads without errors or warnings, and stays reliable even if the themes extension is not available at the exact moment Telescope is configured.

## Fix Applied

Updated Telescope config in both:

- `init.lua`
- `lua/plugins/init.lua`

Change:

- Instead of assigning `telescope.builtin.themes` once (which could fall back to `builtin.colorscheme` if the NvChad themes extension is not available at assignment time), we now assign `telescope.builtin.themes` to a small wrapper function that:
  - Uses `_G._nvchad_open_themes_picker()` when available (dashboard and mappings already use it),
  - Otherwise attempts to load and call `telescope.extensions.themes.themes()` at call-time,
  - Falls back to `builtin.colorscheme()` only if the NvChad themes picker still cannot be invoked.

This keeps the entrypoint accurate and avoids startup bloat.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## How To Restore (Revert)

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

Optionally remove this restore point file:

```bash
rm lua/restore-points/2026-02-15-telescope-nvchad-themes-entrypoint-wrapper-fix.md
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad theme names (base46 themes), not Telescope layout themes (dropdown, ivy, etc).
   - Selecting a theme applies it correctly.

