# Restore Point: Treesitter Extended Fix

**Date:** 2026-02-13T22:07:35-07:00 (Friday)
**Updated:** 2026-02-13T23:53:31-07:00 (Friday)

## Purpose

This restore point documents the fix applied to resolve the nvim-treesitter.configs module error.

## Error Fixed

```
Failed to run `config` for nvim-treesitter-textobjects
module 'nvim-treesitter.configs' not found
```

## Root Cause

nvim-treesitter 1.0+ removed the `nvim-treesitter.configs` module. The file `lua/plugins/treesitter_extended.lua` was attempting to require this non-existent module.

## Fix Applied

Changed `lua/plugins/treesitter_extended.lua` to return an empty table instead of trying to configure treesitter through the removed module. All treesitter configuration is handled in `lua/plugins/treesitter.lua`.

## Files Modified

- `lua/plugins/treesitter_extended.lua` - Removed config function, now returns empty table

## Restore Instructions

If you need to reverse this change (not recommended as it will reintroduce the error):

```bash
# This would restore the broken state - only do this if you have a different fix
git checkout HEAD~1 -- lua/plugins/treesitter_extended.lua
```

## Notes

- The main treesitter configuration remains in `lua/plugins/treesitter.lua`
- This file (`treesitter_extended.lua`) is kept as an empty return to prevent any stale requires from breaking
- Consider deleting `treesitter_extended.lua` entirely if no other files depend on it

---

## Additional Fix: ft_to_lang Shim (2026-02-13T23:53:31)

### Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

### Root Cause

The previous ft_to_lang shim in `init.lua` used a complex proxy table with metatable approach. The proxy table's `rawset` call was not making the function accessible properly because the proxy was empty and relied entirely on `__index` metamethod. When Telescope or other code used direct table access, it got `nil`.

### Fix Applied

Simplified the ft_to_lang shim in `init.lua`:
1. Removed the complex proxy table with metatable approach
2. Directly assign the shim function to `vim.treesitter.language.ft_to_lang`
3. Added a `LazyDone` autocmd to re-apply the shim if any plugin overwrites it

### To Restore Previous (Complex Proxy) Approach

In `init.lua`, replace the simplified shim block with:

```lua
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
