# Restore Point: Telescope NvChad Themes Wrapper Fix

**Date:** 2026-02-15T12:31:58-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` always opens the NvChad themes picker when available, without errors or warnings.

## Fix Applied

Updated Telescope config in `init.lua` and `lua/plugins/init.lua` to override `telescope.builtin.themes` with a wrapper function that:

- Loads the `themes` extension on demand.
- Calls `telescope.extensions.themes.themes(opts)` when available.
- Falls back to `telescope.builtin.colorscheme(opts)` when the extension is unavailable.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## To Restore Previous State

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

## Verification

1. Restart Neovim.
2. Run `:Telescope themes`.
3. Confirm:
   - no errors or warnings are printed
   - the picker shows NvChad theme names, not Telescope layout themes
   - selecting a theme applies it
