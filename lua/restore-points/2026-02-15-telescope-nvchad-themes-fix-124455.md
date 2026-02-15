# Restore Point: Telescope NvChad Themes Reliability Fix

**Date:** 2026-02-15T12:44:55-07:00 (Sunday)

## Goal

Make `:Telescope themes` reliably open the **NvChad themes picker** (not Telescope's builtin layout themes picker), and ensure it opens cleanly with no errors or warnings.

## Problem Observed

Depending on load order, `:Telescope themes` could resolve to Telescope's builtin `themes` picker (layout themes), or fail to route to NvChad's themes extension consistently.

## Fix Applied

Updated Telescope config to always map `telescope.builtin.themes` to a small wrapper function that:

- Tries to load the NvChad `themes` Telescope extension on demand.
- Calls `telescope.extensions.themes.themes()` when available.
- Falls back to `telescope.builtin.colorscheme()` if the extension is unavailable.

This keeps behavior correct and minimal, and avoids relying on extension availability at a specific moment.

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
   - No errors or warnings are printed.
   - The picker shows NvChad themes (not layout themes like dropdown/ivy).
   - Selecting a theme applies it as expected.
