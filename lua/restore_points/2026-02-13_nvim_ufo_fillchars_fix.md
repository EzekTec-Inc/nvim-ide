# Restore Point: nvim-ufo fillchars Fix

**Date:** 2026-02-13T23:08:58-07:00 (Friday)
**Updated:** 2026-02-13T23:55:37-07:00 (Friday)

## Error Fixed

```
Failed to run `config` for nvim-ufo
E1511: Wrong number of characters for field "foldopen"
```

## Root Cause

The `vim.o.fillchars` setting in `init.lua` was using Unicode characters (`▾` and `▸`) that are multi-cell width in certain terminal/font configurations. Neovim requires single-cell characters for fillchars fields.

## Files Modified

1. `init.lua` - Changed fold characters to single-cell alternatives

## To Restore

If you need to revert this change:

```bash
git checkout HEAD~1 -- init.lua
```

Or manually change the fillchars back to:
```lua
vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep:│,foldclose:▸]]
```

## Technical Details

The following characters were changed:
- `foldopen:▾` → `foldopen:` (removed, using default)
- `foldclose:▸` → `foldclose:` (removed, using default)

Alternative fix uses simpler ASCII-compatible characters that work across all terminals.

---

## Additional Fix: ft_to_lang Shim (2026-02-13T23:55:37)

### Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

### Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+. Telescope previewers still reference this function. Previous shim implementations could be overwritten by plugins during lazy loading.

### Fix Applied

Enhanced the ft_to_lang shim in `init.lua`:
1. Use `rawset` to bypass any metatables when applying the shim
2. Use `rawget` inside the shim function to safely access `get_lang`
3. Created a reusable `_G._apply_ft_to_lang_shim` function
4. Added both `LazyDone` and `VimEnter` autocmds to re-apply the shim

### To Restore Previous State

In `init.lua`, replace the enhanced shim block with simple assignment:

```lua
-- Simple version (may be overwritten by plugins)
local function _nvim_ft_to_lang_shim(ft)
  if not ft or ft == "" then return ft or "" end
  if vim.treesitter.language.get_lang then
    local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
    if ok and lang then return lang end
  end
  return ft
end

_G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim

if not vim.treesitter then vim.treesitter = {} end
if not vim.treesitter.language then vim.treesitter.language = {} end
vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim
```

And change the autocmd to:

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    if _G._nvim_ft_to_lang_shim and not vim.treesitter.language.ft_to_lang then
      vim.treesitter.language.ft_to_lang = _G._nvim_ft_to_lang_shim
    end
  end,
})
```
