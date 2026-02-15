# Restore Point: nvim-ufo fillchars E1511 Fix

**Date:** 2026-02-13T23:15:54-07:00 (Friday)
**Related Fix:** 2026-02-13T23:53:35 - ft_to_lang Telescope error (see 2026-02-13-ft-to-lang-fix.md)

## Purpose

This restore point documents the fix applied to resolve the E1511 fillchars error in nvim-ufo configuration.

## Error Fixed

```
Failed to run `config` for nvim-ufo

/home/engr-uba/.config/nvim/init.lua:301: E1511: Wrong number of characters for field "foldopen"

# stacktrace:
  - ~/.config/nvim/init.lua:301 _in_ **config**
  - ~/.config/nvim/lua/mappings.lua:315
  - ~/.config/nvim/init.lua:414
```

## Root Cause

The nvim-ufo plugin was being configured without explicit fold method settings, which caused Neovim to attempt setting fillchars fields (foldopen, foldsep, foldclose) that require single-byte ASCII characters only.

## Fix Applied

Modified `init.lua` nvim-ufo config section to:
1. Removed verbose comments about fillchars
2. Added explicit `foldcolumn` and `foldmethod` settings before ufo setup
3. These settings prevent Neovim from trying to use default fillchars that cause the E1511 error

## Files Modified

- `init.lua` - Updated nvim-ufo config function

## Restore Instructions

To reverse this change:

```bash
git checkout HEAD~1 -- init.lua
```

Or manually restore the previous config in `init.lua` nvim-ufo section:

```lua
config = function()
  vim.o.foldenable = true
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  -- IMPORTANT: Do NOT set foldopen, foldsep, foldclose in fillchars
  -- These fields require single-byte ASCII chars only and cause E1511 error
  -- nvim-ufo handles fold display via fold_virt_text_handler instead
  -- FIX 2026-02-13T23:15:45: Remove fillchars setting entirely from ufo config
  -- The fillchars are already set correctly in lua/options.lua
  -- Setting them here causes duplicate/conflicting assignments
```

## Notes

- The fillchars for fold display are handled by nvim-ufo's `fold_virt_text_handler`
- Basic fillchars (eob, fold) are set in `lua/options.lua`
- Do NOT add foldopen, foldsep, or foldclose to any fillchars setting
