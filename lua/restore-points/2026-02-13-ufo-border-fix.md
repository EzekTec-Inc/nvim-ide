# Restore Point: nvim-ufo Border Fix

**Date:** 2026-02-13T23:15:34-07:00 (Friday)
**Updated:** 2026-02-13T23:53:34-07:00 (Friday)

## Related Fix

See `lua/restore-points/2026-02-13-ft-to-lang-simplified-fix.md` for the latest ft_to_lang fix that was applied in the same session.

## Error Fixed

```
Failed to run `config` for nvim-ufo
E1511: Wrong number of characters for field "foldopen"
```

## Root Cause

The nvim-ufo preview `win_config.border` was using an array of characters `{ "", "-", "", "", "", "-", "", "" }` that Neovim was incorrectly parsing, causing an E1511 error related to fillchars field validation.

## Fix Applied

Changed the border configuration in `init.lua` nvim-ufo config from:
```lua
border = { "", "-", "", "", "", "-", "", "" },
```

To:
```lua
border = "rounded",
```

Using a named border style avoids the character parsing issue entirely.

## Files Modified

- `init.lua` - Changed nvim-ufo preview border from array to named style "rounded"

## To Restore Previous State

If you need to revert this change:

```lua
-- In init.lua nvim-ufo config, change:
border = "rounded",

-- Back to:
border = { "", "-", "", "", "", "-", "", "" },
```

Or use git:
```bash
git checkout HEAD~1 -- init.lua
```

## Verification

After applying this fix:
1. Restart Neovim
2. The E1511 error should no longer appear
3. Code folding with nvim-ufo should work correctly
