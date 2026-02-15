# Restore Point: ft_to_lang Metatable Proxy Fix

**Date:** 2026-02-13T23:58:03-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+. Previous shim implementations using direct assignment were being overwritten by plugins during lazy loading. The simple assignment approach was not robust enough because:

1. Plugins could replace the entire `vim.treesitter.language` table
2. Direct assignments could be overwritten with `nil`
3. Timing issues meant the shim wasn't always in place when Telescope accessed it

## Fix Applied

Replaced the simple direct assignment approach with a metatable proxy:

1. Created a proxy table using `setmetatable` that wraps `vim.treesitter.language`
2. The `__index` metamethod always returns the shim function for `ft_to_lang`
3. The `__newindex` metamethod prevents `ft_to_lang` from being set to `nil`
4. Added `_ensure_ft_to_lang_shim()` function that re-applies the proxy if the table is replaced
5. Multiple safety points: `vim.defer_fn`, `LazyDone` autocmd, and `VimEnter` autocmd

## Files Modified

- `init.lua` - Replaced ft_to_lang shim with metatable proxy approach

## To Restore Previous State

If you need to revert to the previous simple assignment approach:

```lua
-- In init.lua, replace the metatable proxy block with:

-- Ensure vim.treesitter.language table exists
if not vim.treesitter then
  vim.treesitter = {}
end
if not vim.treesitter.language then
  vim.treesitter.language = {}
end

-- Create the shim function
local function _nvim_ft_to_lang_shim(ft)
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

_G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim
vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim

local function _apply_ft_to_lang_shim()
  if _G._nvim_ft_to_lang_shim then
    vim.treesitter.language.ft_to_lang = _G._nvim_ft_to_lang_shim
  end
end
_G._apply_ft_to_lang_shim = _apply_ft_to_lang_shim

vim.defer_fn(_apply_ft_to_lang_shim, 0)

-- And update the autocmds to use _apply_ft_to_lang_shim instead of _ensure_ft_to_lang_shim
```

## Technical Details

The metatable proxy approach works as follows:

- `__index(_, key)`: When accessing any key, if it's `ft_to_lang`, always return the shim function; otherwise return from storage
- `__newindex(_, key, value)`: When setting any key, if it's `ft_to_lang` with `nil` value, ignore it; otherwise store normally
- `__pairs(_)`: Return pairs from storage to allow iteration
- `_language_storage`: Internal table that holds all actual values
- `_real_get_lang`: Stored copy of `get_lang` to avoid recursion in the shim function

This ensures that no matter how code tries to access or modify `vim.treesitter.language.ft_to_lang`, it will always return the shim function.

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command that uses the previewer
3. The error should no longer appear

