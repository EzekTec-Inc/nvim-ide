# Restore Point: ft_to_lang Metatable Proxy Fix

**Date:** 2026-02-13T23:56:45-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+, but Telescope's previewer utilities still reference it. Previous fix attempts used direct assignment which could be overwritten by plugins during lazy loading.

## Fix Applied

Implemented a metatable proxy approach in `init.lua`:
1. Created a proxy table for `vim.treesitter.language` with `__index` and `__newindex` metamethods
2. The `__index` metamethod always returns the shim function when `ft_to_lang` is accessed
3. The `__newindex` metamethod blocks any attempts to overwrite `ft_to_lang` to `nil`
4. Added autocmds to re-apply the proxy if `vim.treesitter.language` is entirely replaced

## Files Modified

- `init.lua` - Replaced simple direct assignment with metatable proxy approach

## To Restore Previous (Simple Assignment) Approach

In `init.lua`, replace the metatable proxy block with:

```lua
-- FIX 2026-02-13T23:55:47: Robust ft_to_lang shim for Neovim 0.10+
-- The ft_to_lang function was removed in Neovim 0.10+
-- Telescope previewers still reference it, causing "attempt to call field 'ft_to_lang' (a nil value)"
-- Solution: Direct assignment with multiple re-application points for robustness

-- Ensure vim.treesitter.language table exists
if not vim.treesitter then
  vim.treesitter = {}
end
if not vim.treesitter.language then
  vim.treesitter.language = {}
end

-- Create the shim function that wraps get_lang (the Neovim 0.10+ replacement)
local function _nvim_ft_to_lang_shim(ft)
  if not ft or ft == "" then
    return ft or ""
  end
  -- Try get_lang first (Neovim 0.10+)
  if vim.treesitter.language.get_lang then
    local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
    if ok and lang then
      return lang
    end
  end
  -- Fallback: return filetype as-is (many filetypes map directly to their language name)
  return ft
end

-- Store in global for persistence and access from other modules
_G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim

-- Apply the shim directly to the table
vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim
```

And replace the autocmds block with:

```lua
-- Re-apply ft_to_lang shim after all plugins load (safety net)
-- Some plugins may overwrite or reset vim.treesitter.language during loading
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = function()
    if not vim.treesitter.language.ft_to_lang then
      vim.treesitter.language.ft_to_lang = _G._nvim_ft_to_lang_shim
    end
  end,
})

-- Also apply on VimEnter as an additional safety net
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if not vim.treesitter.language.ft_to_lang then
      vim.treesitter.language.ft_to_lang = _G._nvim_ft_to_lang_shim
    end
  end,
})
```

## Verification

After applying this fix:
1. Restart Neovim
2. Open Telescope with `:Telescope themes` or similar
3. The ft_to_lang error should no longer appear
4. Preview functionality should work correctly
