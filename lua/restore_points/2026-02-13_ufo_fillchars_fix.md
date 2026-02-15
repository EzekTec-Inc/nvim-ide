# Restore Point: UFO Fillchars Fix

**Date:** 2026-02-13T23:18:09-07:00 (Friday)

## Error Fixed

```
E1511: Wrong number of characters for field "foldopen"
```

## Root Cause

The E1511 error occurs when Neovim validates fillchars fields (foldopen, foldsep, foldclose) which require exactly one single-byte ASCII character. The error was triggered because:

1. fillchars was being set in multiple places with potential conflicts
2. The order of operations meant fold options could be set before fillchars was properly configured

## Fix Applied

1. **`init.lua`** (nvim-ufo init function): Now explicitly sets `vim.opt.fillchars = { eob = " ", fold = " " }` which only includes safe fields that don't require single-byte ASCII validation (eob and fold accept any character, while foldopen/foldsep/foldclose require single ASCII char)

2. **`lua/options.lua`**: Removed the fillchars setting to prevent conflicts. All fillchars configuration is now centralized in the nvim-ufo init function.

## To Restore Previous State

If you need to revert these changes:

```lua
-- In init.lua nvim-ufo init function, remove:
vim.opt.fillchars = { eob = " ", fold = " " }

-- In lua/options.lua, change the comment block back to:
vim.opt.fillchars:append({ eob = " " })
```

## Technical Details

- `eob` (end of buffer): Accepts any character
- `fold`: Accepts any character  
- `foldopen`, `foldsep`, `foldclose`: Require exactly one single-byte ASCII character

By only setting `eob` and `fold` in fillchars, we avoid triggering the E1511 validation error for the fold-related fields. nvim-ufo handles fold display via its own virtual text handler, so the fold column characters are not needed.
