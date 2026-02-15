# Restore Point: fillchars E1511 Fix

**Date:** 2026-02-13T23:10:40-07:00 (Friday)

## Error Fixed

```
Failed to run `config` for nvim-ufo

/home/engr-uba/.config/nvim/init.lua:301: E1511: Wrong number of characters for field "foldopen"
```

## Root Cause

The `vim.o.fillchars` string was using Lua's `[[...]]` raw string syntax which can cause issues with how Neovim parses the fillchars option. The `foldopen`, `foldsep`, and `foldclose` fields require exactly one single-byte ASCII character each.

## Fix Applied

Changed fillchars assignment from:
```lua
vim.o.fillchars = [[eob: ,fold: ]]
```

To:
```lua
vim.o.fillchars = "eob: ,fold: "
```

This was applied in:
- `init.lua` (line 301)
- `lua/plugins/ufo.lua`

## To Restore Previous State

```bash
git checkout HEAD~1 -- init.lua lua/plugins/ufo.lua
```

## Notes

When using nvim-ufo for folding:
- Do NOT set `foldopen`, `foldsep`, or `foldclose` in fillchars
- nvim-ufo handles fold display via `fold_virt_text_handler`
- These fields require single-byte ASCII characters only
