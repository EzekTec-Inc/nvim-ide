# Restore Point: ft_to_lang Metatable Proxy Fix

**Date:** 2026-02-13T23:58:08-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+. Previous fix attempts used direct assignment which could be overwritten by plugins during lazy loading. Even with re-application autocmds, race conditions allowed the function to be nil when Telescope accessed it.

## Fix Applied

Replaced the direct assignment approach with a metatable proxy on `vim.treesitter.language`:

1. Created a proxy table with `__index` metamethod that always returns the shim function when `ft_to_lang` is accessed
2. Added `__newindex` metamethod that silently ignores attempts to set `ft_to_lang` to nil or any other value
3. Stored all original `vim.treesitter.language` contents in a separate storage table
4. The proxy intercepts all reads/writes, ensuring `ft_to_lang` can never be nil

## Files Modified

- `init.lua` - Replaced simple ft_to_lang shim with metatable proxy approach

## To Restore Previous State

Replace the metatable proxy block in `init.lua` (lines 7-70 approximately) with:

```lua
-- FIX 2026-02-13T23:57:22: Simplified ft_to_lang shim for Neovim 0.10+
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
```

And add at the end of the file (before `vim.schedule`):

```lua
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    if _G._apply_ft_to_lang_shim then
      _G._apply_ft_to_lang_shim()
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if _G._apply_ft_to_lang_shim then
      _G._apply_ft_to_lang_shim()
    end
  end,
})
```

## Technical Details

The metatable approach works because:

1. `__index` metamethod is called whenever a key is accessed that doesn't exist in the table
2. Since we use an empty proxy table, ALL accesses go through `__index`
3. For `ft_to_lang`, we always return the shim function
4. For other keys, we return from the storage table
5. `__newindex` prevents any writes to `ft_to_lang` from taking effect
6. This makes the shim effectively immutable and always available

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The error should no longer appear
