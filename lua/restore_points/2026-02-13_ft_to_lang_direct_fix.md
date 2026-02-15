# Restore Point: ft_to_lang Direct Assignment Fix

**Date:** 2026-02-13T23:55:47-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The previous fix used a metatable proxy approach to ensure `ft_to_lang` was always available. However, the proxy table was empty and relied entirely on the `__index` metamethod. When Telescope's previewer code accessed `vim.treesitter.language.ft_to_lang`, the metamethod was not being triggered correctly in all code paths, resulting in `nil`.

## Fix Applied

Simplified the ft_to_lang shim in `init.lua`:

1. Removed the complex metatable proxy approach
2. Use direct assignment: `vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim`
3. Added multiple autocmd safety nets (LazyDone and VimEnter) to re-apply the shim if any plugin overwrites it

## Files Modified

- `init.lua` - Simplified ft_to_lang shim implementation

## To Restore Previous (Metatable Proxy) State

If you need to revert to the metatable proxy approach:

```lua
-- In init.lua, replace the simplified shim block with:

-- Store original table contents
local _original_language = vim.treesitter.language
local _language_data = {}
for k, v in pairs(_original_language) do
  _language_data[k] = v
end
_language_data.ft_to_lang = _nvim_ft_to_lang_shim

-- Create a proxy table with metatable that always returns ft_to_lang
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
2. Open Telescope with `:Telescope find_files` or `:Telescope themes`
3. The ft_to_lang error should no longer appear
4. File previews should work correctly
