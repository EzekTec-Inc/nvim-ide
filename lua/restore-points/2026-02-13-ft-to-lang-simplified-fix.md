# Restore Point: ft_to_lang Simplified Fix

**Date:** 2026-02-13T23:54:56-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The previous metatable proxy approach for the ft_to_lang shim was not working correctly. The proxy table was created empty with `setmetatable({}, proxy_mt)`, and when Telescope or other code accessed `vim.treesitter.language.ft_to_lang` directly, it received `nil` because:

1. The proxy table itself was empty
2. The `rawset` was done on `original_ts_lang`, not on the proxy
3. Some code paths may bypass the `__index` metamethod

## Fix Applied

Simplified the shim implementation in `init.lua`:
1. Removed the complex metatable proxy approach
2. Use direct assignment: `vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim`
3. Added a VimEnter autocmd to re-apply the shim if it gets overwritten during plugin loading

## Files Modified

- `init.lua` - Simplified ft_to_lang shim implementation

## To Restore Previous (Metatable Proxy) State

If you need to revert to the previous metatable proxy approach:

```lua
-- In init.lua, replace the simplified shim with:

-- Store the original table
local original_ts_lang = vim.treesitter.language

-- Create a proxy table with metatable that always returns ft_to_lang
local proxy_mt = {
  __index = function(_, key)
    if key == "ft_to_lang" then
      return _G._nvim_ft_to_lang_shim
    end
    return rawget(original_ts_lang, key)
  end,
  __newindex = function(_, key, value)
    if key == "ft_to_lang" then
      if value ~= nil then
        rawset(original_ts_lang, key, value)
      end
    else
      rawset(original_ts_lang, key, value)
    end
  end,
}

rawset(original_ts_lang, "ft_to_lang", _nvim_ft_to_lang_shim)
vim.treesitter.language = setmetatable({}, proxy_mt)

for k, v in pairs(original_ts_lang) do
  if k ~= "ft_to_lang" then
    rawset(original_ts_lang, k, v)
  end
end
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The ft_to_lang error should no longer appear
