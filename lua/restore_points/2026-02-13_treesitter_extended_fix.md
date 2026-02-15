# Restore Point: Treesitter Extended Fix

**Date:** 2026-02-13T22:08:35-07:00 (Friday)
**Updated:** 2026-02-13T23:17:35-07:00 (Friday)

## Error Fixed

```
Failed to run `config` for nvim-treesitter-textobjects

module 'nvim-treesitter.configs' not found
```

## Root Cause

The file `lua/plugins/treesitter_extended.lua` had a config function that was attempting to require `nvim-treesitter.configs`, which no longer exists in nvim-treesitter 1.0+.

## Fix Applied

Changed `lua/plugins/treesitter_extended.lua` to return an empty table with no config function. All treesitter configuration is handled in `lua/plugins/treesitter.lua`.

## Additional Fix Applied 2026-02-13T23:17:35

Fixed E1511 error "Wrong number of characters for field foldopen" in nvim-ufo config:

1. **`init.lua`**: Added `vim.o.foldmethod = "manual"` in nvim-ufo init function to ensure fold method is set before any fold operations occur
2. **`lua/options.lua`**: Changed from `vim.o.fillchars = "eob: ,fold: "` to `vim.opt.fillchars:append({ eob = " ", fold = " " })` to use the append method which avoids overwriting any existing fillchars settings

The E1511 error occurs when Neovim tries to validate fillchars containing foldopen/foldsep/foldclose fields with invalid characters. By ensuring foldcolumn is "0" before any fold operations and using the append method for fillchars, we avoid triggering the validation.

## To Restore Previous (Broken) State

If for some reason you need to restore the broken state:

```bash
git checkout HEAD~1 -- lua/plugins/treesitter_extended.lua
```

To restore the nvim-ufo fix:
```lua
-- In lua/options.lua, change:
vim.opt.fillchars:append({ eob = " ", fold = " " })
-- Back to:
vim.o.fillchars = "eob: ,fold: "

-- In init.lua nvim-ufo init function, remove:
vim.o.foldmethod = "manual"
```

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Lazy sync`
3. The error should no longer appear

## Additional Fix Applied 2026-02-13T23:56:58

Fixed Telescope ft_to_lang error "attempt to call field 'ft_to_lang' (a nil value)":

**Problem:** The metatable proxy approach for `vim.treesitter.language.ft_to_lang` was not sufficient because some code paths (including Telescope previewers) may use `rawget()` or direct table access that bypasses the metatable `__index` metamethod.

**Solution:** Added `rawset(_ts_lang_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)` after creating the proxy table to ensure the function is set directly on the table itself, not just accessible via the metatable. Also updated the LazyDone autocmd to always re-apply the shim unconditionally.

**To restore previous state:**
```lua
-- In init.lua, remove the rawset line after proxy creation:
rawset(_ts_lang_proxy, "ft_to_lang", _nvim_ft_to_lang_shim)

-- In the LazyDone autocmd callback, change back to conditional check:
local current_ft_to_lang = rawget(vim.treesitter.language, "ft_to_lang")
if current_ft_to_lang == nil and _G._nvim_ft_to_lang_shim then
  rawset(vim.treesitter.language, "ft_to_lang", _G._nvim_ft_to_lang_shim)
end
```
