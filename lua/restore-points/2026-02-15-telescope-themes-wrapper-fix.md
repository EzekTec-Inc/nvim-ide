# Restore Point: Telescope NvChad Themes Wrapper Fix

**Date:** 2026-02-15T12:24:33-07:00 (Sunday)

## Goal

Make `:Telescope themes` reliably open the NvChad themes picker, load without errors or warnings, and behave consistently.

## Issue Observed

`Telescope themes` can end up invoking a non-NvChad picker (for example Telescope's builtin picker), depending on load order and how the picker is resolved.

## Fix Applied

Updated Telescope config in both `init.lua` and `lua/plugins/init.lua`:

- Replaced the one-time assignment of `telescope.builtin.themes` with a small wrapper function.
- The wrapper:
  - attempts `telescope.load_extension("themes")`
  - delegates to `telescope.extensions.themes.themes(...)` when available
  - otherwise falls back to `telescope.builtin.colorscheme(...)`

This makes `:Telescope themes` consistently route to NvChad themes when available, without adding extra plugin load behavior.

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
   - the picker shows NvChad theme names
   - selecting a theme applies correctly
