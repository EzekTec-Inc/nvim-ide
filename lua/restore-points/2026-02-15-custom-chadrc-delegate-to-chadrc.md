# Restore Point: Fix NvChad Telescope themes picker via custom chadrc delegation

**Date:** 2026-02-15T12:45:52-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker flow works accurately when triggered via `:Telescope themes` or NvChad UI entrypoints, with no errors or warnings, and without adding bloat.

## Root Cause

Some NvChad components and integrations can still `require("custom.chadrc")` (legacy path).  
In this config, `lua/custom/chadrc.lua` returned an empty table, so theme related configuration and helper wiring in `lua/chadrc.lua` was not guaranteed to be loaded when those legacy entrypoints were used.

This could cause the theme picker to behave inconsistently or fall back to Telescope's builtin `themes` picker (layout themes) instead of the NvChad themes picker.

## Fix Applied

Updated:

- `lua/custom/chadrc.lua`

Changed it to delegate to the real config by returning:

- `return require "chadrc"`

This keeps backward compatibility for legacy `custom.chadrc` entrypoints, while preserving the actual configuration in `lua/chadrc.lua`.

## Files Modified

- `lua/custom/chadrc.lua`

## How To Restore

Revert the delegation change in `lua/custom/chadrc.lua`:

- Change `return require "chadrc"` back to `return M`

Or via git (if committed):

```bash
git checkout HEAD~1 -- lua/custom/chadrc.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - no errors or warnings are printed
   - the picker shows NvChad theme names (not Telescope layout themes)
   - selecting a theme applies it as expected
