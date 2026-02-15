# Restore Point: ft_to_lang Telescope Error Fix

**Date:** 2026-02-13T23:53:35-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

In Neovim 0.10+, `vim.treesitter.language.ft_to_lang` was removed. Telescope's previewer utils still references this function, causing a nil call error when previewing files.

The previous fix attempt used a proxy metatable approach which was overly complex and failed because:
1. The proxy table approach interfered with normal table access patterns
2. `rawget` bypasses metatables, so code using `rawget` would still get nil

## Fix Applied

Simplified the shim in `init.lua` to use direct assignment with defensive re-application:

1. Direct assignment: `vim.treesitter.language.ft_to_lang = ft_to_lang_shim`
2. Deferred re-application after 100ms to catch lazy-loaded module resets
3. VimEnter autocmd to catch any late resets

The shim function:
- Returns empty string for nil/empty input
- Tries `vim.treesitter.language.get_lang()` first (Neovim 0.10+ API)
- Falls back to returning the filetype as-is (works for most languages)

## Files Modified

- `init.lua` - Simplified ft_to_lang shim implementation

## To Restore Previous State

If you need to revert to the proxy metatable approach:

```lua
-- In init.lua, replace the ft_to_lang shim block with:
do
  local function ft_to_lang_shim(ft)
    if not ft or ft == "" then return ft or "" end
    local get_lang = rawget(vim.treesitter.language, "get_lang")
    if get_lang then
      local ok, lang = pcall(get_lang, ft)
      if ok and lang then return lang end
    end
    return ft
  end
  
  _G._nvim_ft_to_lang_shim = ft_to_lang_shim
  
  if not vim.treesitter then vim.treesitter = {} end
  if not vim.treesitter.language then vim.treesitter.language = {} end
  
  local original_language = vim.treesitter.language
  local language_contents = {}
  for k, v in pairs(original_language) do
    language_contents[k] = v
  end
  language_contents.ft_to_lang = ft_to_lang_shim
  
  local proxy = {}
  local mt = {
    __index = function(_, key)
      if key == "ft_to_lang" then return ft_to_lang_shim end
      return language_contents[key]
    end,
    __newindex = function(_, key, value)
      if key ~= "ft_to_lang" then language_contents[key] = value end
    end,
    __pairs = function(_) return pairs(language_contents) end,
  }
  setmetatable(proxy, mt)
  vim.treesitter.language = proxy
  rawset(proxy, "ft_to_lang", ft_to_lang_shim)
end
```

## Verification

After applying this fix:
1. Restart Neovim
2. Open Telescope with `:Telescope find_files`
3. Navigate through files - preview should work without errors
4. Try `:Telescope themes` - should work without ft_to_lang errors
