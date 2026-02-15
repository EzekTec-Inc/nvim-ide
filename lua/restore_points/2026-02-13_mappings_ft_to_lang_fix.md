# Restore Point: Mappings ft_to_lang Fix

**Date:** 2026-02-13T23:41:36-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+, but Telescope's previewers still call it. While a shim exists in `init.lua`, it may not be applied early enough in all code paths, particularly when `mappings.lua` is loaded via `vim.schedule`.

## Fix Applied

Added a safety net shim at the top of `lua/mappings.lua` that ensures `ft_to_lang` is defined before any telescope-related code might be triggered by mappings.

## Files Modified

- `lua/mappings.lua` - Added ft_to_lang shim as safety net

## To Restore Previous State

Remove the shim block from `lua/mappings.lua`:

```lua
-- Remove this block from lua/mappings.lua (after "require nvchad.mappings"):
-- FIX 2026-02-13T23:41:36: Ensure ft_to_lang shim is applied before any telescope usage
-- This is a safety net in case init.lua shim wasn't applied early enough
if vim.treesitter and vim.treesitter.language then
  if type(vim.treesitter.language.ft_to_lang) ~= "function" then
    vim.treesitter.language.ft_to_lang = function(ft)
      if not ft or ft == "" then
        return ""
      end
      if type(vim.treesitter.language.get_lang) == "function" then
        local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
        if ok and lang then
          return lang
        end
      end
      return ft
    end
  end
end
```

## Verification

After applying this fix:
1. Restart Neovim
2. Open Telescope with `:Telescope themes` or `:Telescope find_files`
3. The ft_to_lang error should no longer appear
