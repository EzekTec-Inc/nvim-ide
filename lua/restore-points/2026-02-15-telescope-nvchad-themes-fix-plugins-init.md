# Restore Point: Telescope NvChad Themes Fix (plugins/init.lua)

**Date:** 2026-02-15T13:20:27-07:00 (Sunday)

## Goal

Make `:Telescope themes` reliably open the NvChad themes picker (theme colorschemes list), not Telescope's builtin layout themes picker, and do so without errors or warnings.

## Change Applied

Updated `lua/plugins/init.lua` in the Telescope plugin `config` to:

- Ensure the `themes` extension is loaded.
- Force `telescope.builtin.themes` to route to the NvChad themes picker when available.
- Fall back to `telescope.builtin.colorscheme` if the themes extension picker is not available or fails.

This keeps the behavior robust across plugin load timing, while staying minimal and not adding new plugins or extra complexity.

## Files Modified

- `lua/plugins/init.lua`

## How To Restore

Revert the last change with git:

```bash
git checkout HEAD~1 -- lua/plugins/init.lua
```

Optionally delete this restore point file:

```bash
rm lua/restore-points/2026-02-15-telescope-nvchad-themes-fix-plugins-init.md
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows theme names (colorschemes).
   - Selecting a theme applies it cleanly.
