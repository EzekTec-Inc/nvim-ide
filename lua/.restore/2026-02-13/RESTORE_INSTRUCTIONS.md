# Restore Instructions - 2026-02-13

## Purpose
This directory contains backup files created before the nvim migration from the backup configuration at `~/.config/nvim-jan-2026-working.bak/`.

## Files Backed Up
- `chadrc.lua.bak` - Original chadrc.lua
- `mappings.lua.bak` - Original mappings.lua
- `plugins-init.lua.bak` - Original plugins/init.lua

## To Restore

### Option 1: Manual Restore
```bash
# From your nvim config directory (~/.config/nvim)
cp lua/.restore/2026-02-13/chadrc.lua.bak lua/chadrc.lua
cp lua/.restore/2026-02-13/mappings.lua.bak lua/mappings.lua
cp lua/.restore/2026-02-13/plugins-init.lua.bak lua/plugins/init.lua
```

### Option 2: Full Restore Script
```bash
cd ~/.config/nvim
for f in lua/.restore/2026-02-13/*.bak; do
  target="${f%.bak}"
  target="${target#lua/.restore/2026-02-13/}"
  if [[ "$target" == "plugins-init.lua" ]]; then
    cp "$f" "lua/plugins/init.lua"
  else
    cp "$f" "lua/$target"
  fi
done
```

## After Restore
1. Restart Neovim
2. Run `:Lazy sync` to sync plugins
3. Run `:checkhealth` to verify configuration

## Latest Fix - 2026-02-13T23:37:25

### Telescope ft_to_lang Error Fix

**Error:** `attempt to call field 'ft_to_lang' (a nil value)`

**Root Cause:** In Neovim 0.10+, `vim.treesitter.language.ft_to_lang` was removed. Telescope's previewer still tries to call this function.

**Fix Applied:**
- Added compatibility shim in `init.lua` that creates `vim.treesitter.language.ft_to_lang` using `vim.treesitter.language.get_lang`
- Also added shim to `lua/configs/treesitter.lua` for completeness

**To Restore Previous State (remove the fix):**
```lua
-- In init.lua, remove these lines after vim.g.mapleader:
if vim.treesitter.language and not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = function(filetype)
    if vim.treesitter.language.get_lang then
      return vim.treesitter.language.get_lang(filetype)
    end
    return filetype
  end
end

-- In lua/configs/treesitter.lua, remove the similar shim block
```
