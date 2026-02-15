# Restore Point: Telescope NvChad Themes Picker Hardening

**Date:** 2026-02-15T13:23:35-07:00 (Sunday)

## Goal

Make the "NvChad themes" picker entrypoints reliable and accurate:

- `:Telescope themes` routes to the NvChad themes picker when available
- `<leader>th` and NvChad dashboard theme button load cleanly
- No errors or warnings during lazy loading
- Avoid adding bloat or extra plugins

## Changes Applied

1. **Prefer the existing NvChad themes picker entrypoint**
   - `init.lua`: `_apply_telescope_nvchad_themes_picker()` now first tries to route `telescope.builtin.themes` to `_G._nvchad_open_themes_picker(opts)` (defined in `lua/chadrc.lua`).
   - This keeps a single canonical picker path and avoids relying on extension availability at the exact moment `:Telescope themes` is invoked.

2. **Ensure base46 is loadable before opening the picker**
   - `lua/chadrc.lua`: `_G._nvchad_open_themes_picker(opts)` now attempts to `require("base46")`, and if it is not yet loadable, it asks lazy.nvim to load `base46` first.
   - This prevents theme application paths from failing due to `base46` not being on runtimepath yet.

## Files Modified

- `init.lua`
- `lua/chadrc.lua`

## To Restore Previous State

Use git to revert the last change:

```bash
git checkout HEAD~1 -- init.lua lua/chadrc.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
   - `<leader>th`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad themes and selecting one applies it.
