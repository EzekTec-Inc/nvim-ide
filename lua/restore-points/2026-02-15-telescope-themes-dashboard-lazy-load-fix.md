# Restore Point: Telescope NvChad Themes Dashboard Lazy Load Fix

**Date:** 2026-02-15T12:29:27-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker works reliably:

- From the NvChad dashboard "Themes" button.
- From `:Telescope themes`.

## Problem Observed

The dashboard button runs:

- `lua _G._nvchad_open_themes_picker()`

When Telescope is lazy-loaded (loaded on the `Telescope` command), `pcall(require, "telescope")` can fail before Telescope is loaded, which results in the picker not opening.

## Fix Applied

Updated `lua/chadrc.lua` `_G._nvchad_open_themes_picker()` so that if `require("telescope")` fails, it invokes:

- `:Telescope themes`

This triggers lazy-loading and opens the themes picker without errors or warnings.

## Files Modified

- `lua/chadrc.lua`

## To Restore Previous State

```bash
git checkout HEAD~1 -- lua/chadrc.lua
```

## Verification Steps

1. Restart Neovim.
2. On the dashboard, select "Themes".
3. Run `:Telescope themes`.
4. Confirm:
   - no errors or warnings are printed
   - the picker opens and behaves normally
   - the list corresponds to NvChad themes (not Telescope layout themes)
