# Restore Point: Telescope NvChad Themes Builtin Alias Fix

**Date:** 2026-02-15T12:38:13-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` reliably opens the **NvChad theme picker** (base46 themes), loads without errors or warnings, and behaves consistently from:

- `:Telescope themes`
- mappings like `<leader>th`
- NvChad dashboard button that calls `lua _G._nvchad_open_themes_picker()`

## Problem Observed

The implementation was repeatedly calling `telescope.load_extension("themes")` on each invocation path (both from Telescope config and from the dashboard picker function). Even when safe-wrapped, repeated loading attempts can contribute to noisy behavior and inconsistent resolution.

## Fix Applied

After Telescope setup and extension loading:

- Alias `telescope.builtin.themes` directly to `telescope.extensions.themes.themes` when available.
- Fallback: if the NvChad themes picker is not available, alias `telescope.builtin.themes` to `telescope.builtin.colorscheme`.
- In `lua/chadrc.lua`, only call `telescope.load_extension("themes")` when the themes extension is not already available.

This keeps behavior correct and avoids repeated extension load attempts.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`
- `lua/chadrc.lua`

## How To Restore

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua lua/chadrc.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings.
   - The picker shows NvChad/base46 theme names, not Telescope layout themes.
   - Selecting a theme applies it correctly.
