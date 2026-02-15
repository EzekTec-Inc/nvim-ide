# Restore Point: Treesitter Module Fix

**Date:** 2026-02-13T22:01:26-07:00 (Friday)

## Issue

Error when loading nvim-treesitter-textobjects:

```
module 'nvim-treesitter.configs' not found
```

## Root Cause

nvim-treesitter 1.0+ changed its module structure. The old API used `require("nvim-treesitter.configs").setup()` but the new API uses `require("nvim-treesitter").setup()` directly.

## Files Modified

1. `lua/plugins/treesitter.lua` - Updated config function to try new API first, then fall back to old API
2. `lua/plugins/treesitter_extended.lua` - Added documentation comment about the fix

## How to Restore

If this fix causes issues, revert `lua/plugins/treesitter.lua` config function to:

```lua
config = function(_, opts)
  pcall(function()
    if vim.g.base46_cache and type(vim.g.base46_cache) == "string" then
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
    end
  end)

  local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
  if ok then
    ts_configs.setup(opts)
  else
    local ts_ok, treesitter = pcall(require, "nvim-treesitter")
    if ts_ok and treesitter.setup then
      treesitter.setup(opts)
    end
  end
end,
```

## Additional Steps

After applying the fix, run:

1. `:Lazy sync` to refresh plugin state
2. `:TSUpdate` to ensure treesitter parsers are up to date
3. Restart Neovim to clear any cached state
