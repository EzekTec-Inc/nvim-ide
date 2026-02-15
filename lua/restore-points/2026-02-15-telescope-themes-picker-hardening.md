# Restore Point: Telescope NvChad Themes Picker Hardening

**Date:** 2026-02-15T12:51:42-07:00 (Sunday)

## Goal

Ensure `:Telescope themes` reliably opens the NvChad themes picker when available, avoids preview-related errors, and does not emit warnings during normal use.

## Fix Applied

Updated `lua/plugins/init.lua` Telescope config to make the `themes` picker resolution more robust:

- Sets `telescope.builtin.themes` to a small wrapper function that:
  - Re-applies the `ft_to_lang` shim (if available) before opening the picker.
  - Ensures the Telescope `themes` extension is loaded when possible.
  - Falls back to `builtin.colorscheme()` if the NvChad themes extension is unavailable.

- Re-applies the `builtin.themes` override via `vim.schedule(...)` as a safety net in case another module overwrites it during startup.

## Files Modified

- `lua/plugins/init.lua`

## To Restore Previous State

Use git to revert the change:

```bash
git checkout HEAD~1 -- lua/plugins/init.lua
```

Or, in `lua/plugins/init.lua`, restore the previous block that directly assigned:

- `builtin.themes = themes_ext.themes` when available, otherwise
- `builtin.themes = builtin.colorscheme`

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker opens consistently.
   - Selecting a theme applies cleanly.
