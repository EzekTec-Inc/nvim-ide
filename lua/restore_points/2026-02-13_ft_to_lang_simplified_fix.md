# Restore Point: ft_to_lang Simplified Fix

**Date:** 2026-02-13T23:57:41-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+. Telescope previewers still reference this function. The previous fix used a metatable proxy approach, but the proxy table could be replaced by lazy-loaded modules, causing the shim to be lost.

## Fix Applied

Simplified the shim implementation in `init.lua`:
1. Removed complex metatable proxy approach
2. Use direct assignment: `vim.treesitter.language.ft_to_lang = _G._nvim_ft_to_lang_shim`
3. Created `_G._apply_ft_to_lang_shim()` function for easy re-application
4. Apply shim at multiple points:
   - Immediately on load
   - After 1ms delay via `vim.defer_fn`
   - On `LazyDone` event (after plugins load)
   - On `VimEnter` event (after full initialization)

## Files Modified

- `init.lua` - Simplified ft_to_lang shim implementation

## To Restore Previous (Metatable Proxy) State

If you need to revert to the previous metatable proxy approach:

```lua
-- In init.lua, replace the simplified shim block with:

-- Ensure vim.treesitter.language table exists
if not vim.treesitter then
  vim.treesitter = {}
end
if not vim.treesitter.language then
  vim.treesitter.language = {}
end

local function _nvim_ft_to_lang_shim(ft)
  if not ft or ft == "" then
    return ft or ""
  end
  local get_lang = rawget(vim.treesitter.language, "get_lang")
  if get_lang then
    local ok, lang = pcall(get_lang, ft)
    if ok and lang then
      return lang
    end
  end
  return ft
end

_G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim

local _ts_lang_contents = {}
for k, v in pairs(vim.treesitter.language) do
  _ts_lang_contents[k] = v
end
_ts_lang_contents.ft_to_lang = _nvim_ft_to_lang_shim

local _ts_lang_proxy = setmetatable({}, {
  __index = function(_, key)
    if key == "ft_to_lang" then
      return _nvim_ft_to_lang_shim
    end
    return _ts_lang_contents[key]
  end,
  __newindex = function(_, key, value)
    if key == "ft_to_lang" then
      if value ~= nil then
        _ts_lang_contents[key] = value
      end
    else
      _ts_lang_contents[key] = value
    end
  end,
  __pairs = function(_)
    return pairs(_ts_lang_contents)
  end,
})

rawset(_ts_lang_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)
vim.treesitter.language = _ts_lang_proxy

-- And change the LazyDone autocmd back to:
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    if _G._nvim_ft_to_lang_shim then
      rawset(vim.treesitter.language, "ft_to_lang", _G._nvim_ft_to_lang_shim)
    end
  end,
})
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The ft_to_lang error should no longer appear
