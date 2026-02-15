# Restore Point: Telescope ft_to_lang Fix

**Date:** 2026-02-13T23:51:54-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

In Neovim 0.10+, `vim.treesitter.language.ft_to_lang` was removed. However, Telescope's previewer utils still call this function. The previous shim in `init.lua` was being applied but could potentially be overwritten by lazy-loaded modules before Telescope loaded.

## Fix Applied

Enhanced the ft_to_lang shim in `init.lua` to:
1. Use `rawset` to bypass any existing metatables when setting the shim
2. Install a metatable with `__newindex` protection to prevent the shim from being overwritten
3. The shim silently ignores any attempts to overwrite `ft_to_lang`, ensuring it remains available for Telescope

## Files Modified

- `init.lua` - Enhanced ft_to_lang shim with metatable protection

## To Restore Previous State

If this fix causes issues, revert the ft_to_lang shim block in `init.lua`:

```lua
-- In init.lua, replace the current shim block with:
do
  local function ft_to_lang_shim(ft)
    if not ft or ft == "" then
      return ft or ""
    end
    if vim.treesitter.language.get_lang then
      local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
      if ok and lang then
        return lang
      end
    end
    return ft
  end
  
  _G._nvim_ft_to_lang_shim = ft_to_lang_shim
  vim.treesitter.language.ft_to_lang = ft_to_lang_shim
  
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if not vim.treesitter.language.ft_to_lang then
        vim.treesitter.language.ft_to_lang = _G._nvim_ft_to_lang_shim
      end
    end,
    once = true,
  })
end
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The "attempt to call field 'ft_to_lang' (a nil value)" error should no longer appear
