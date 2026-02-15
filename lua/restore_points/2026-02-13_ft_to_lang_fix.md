# Restore Point: ft_to_lang Fix

**Date:** 2026-02-13T23:49:30-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+. Telescope's previewers still reference this function. The previous shim in `init.lua` was being applied but may have been overwritten by lazy-loaded modules or the `rawset` approach wasn't working correctly with metatables.

## Fix Applied

1. **`init.lua`**: Enhanced the ft_to_lang shim to use a metatable-based approach that intercepts all accesses to `vim.treesitter.language` and ensures `ft_to_lang` always returns the shim function.

2. **`lua/configs/telescope.lua`**: Added a pre-setup check to ensure the shim is in place before Telescope initializes.

## To Restore Previous State

```lua
-- In init.lua, replace the ft_to_lang shim block with:
do
  vim.treesitter = vim.treesitter or {}
  vim.treesitter.language = vim.treesitter.language or {}
  
  local function ft_to_lang_shim(ft)
    if not ft or ft == "" then
      return ft or ""
    end
    local get_lang = vim.treesitter.language.get_lang
    if get_lang then
      local ok, lang = pcall(get_lang, ft)
      if ok and lang then
        return lang
      end
    end
    return ft
  end
  
  _G._nvim_ft_to_lang_shim = ft_to_lang_shim
  rawset(vim.treesitter.language, "ft_to_lang", ft_to_lang_shim)
end
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The ft_to_lang error should no longer appear
