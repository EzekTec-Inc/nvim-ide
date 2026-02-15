# Restore Point: ft_to_lang Simple Fix

**Date:** 2026-02-13T23:56:05-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The previous metatable proxy approach for the `ft_to_lang` shim was not working correctly. The proxy table was empty and relied on `__index` metamethod, but Telescope's direct table access was returning `nil` instead of triggering the metamethod properly.

## Fix Applied

Simplified the shim implementation in `init.lua`:
1. Removed the complex metatable proxy approach
2. Used direct assignment: `vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim`
3. Added VimEnter autocmd as additional safety net alongside LazyDone

## To Restore Previous (Metatable Proxy) State

In `init.lua`, replace the simplified shim block with:

```lua
-- Store original table contents
local _original_language = vim.treesitter.language
local _language_data = {}
for k, v in pairs(_original_language) do
  _language_data[k] = v
end
_language_data.ft_to_lang = _nvim_ft_to_lang_shim

-- Create a proxy table with metatable
local _language_proxy = setmetatable({}, {
  __index = function(_, key)
    if key == "ft_to_lang" then
      return _nvim_ft_to_lang_shim
    end
    return _language_data[key]
  end,
  __newindex = function(_, key, value)
    if key == "ft_to_lang" and value == nil then
      return
    end
    _language_data[key] = value
  end,
  __pairs = function(_)
    return pairs(_language_data)
  end,
})

vim.treesitter.language = _language_proxy
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The error should no longer appear
