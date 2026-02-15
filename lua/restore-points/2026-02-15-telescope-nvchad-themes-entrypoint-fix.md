# Restore Point: Telescope NvChad Themes Entrypoint Fix

**Date:** 2026-02-15T12:24:49-07:00 (Sunday)

## Goal

Ensure the NvChad themes picker is opened reliably from the dashboard Themes button, without depending on how `:Telescope themes` resolves (Telescope builtin layout themes picker vs NvChad themes extension).

## Change Applied

- `lua/chadrc.lua`
  - Added a small, safe global entrypoint function: `_G._nvchad_open_themes_picker()`
    - Tries to open NvChad's Telescope themes extension picker
    - Falls back to `telescope.builtin.colorscheme()` if the extension is not available
  - Updated the NvDash "Themes" button action to call:
    - `lua _G._nvchad_open_themes_picker()`

## Files Modified

- `lua/chadrc.lua`

## To Restore Previous State

In `lua/chadrc.lua`:

1. Change the NvDash Themes button action back to:

- From:
  - `lua _G._nvchad_open_themes_picker()`
- To:
  - `Telescope themes`

2. Remove the `_G._nvchad_open_themes_picker` block that was added above `local options = { ... }`.

Then restart Neovim.

## Verification

- Restart Neovim
- From the dashboard, trigger the "Themes" button
- Confirm:
  - No errors or warnings are printed
  - The picker shows NvChad theme names and applying a theme works as expected
