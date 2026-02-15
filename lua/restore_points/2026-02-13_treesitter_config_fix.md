# Restore Point: Treesitter Config Fix

**Date:** 2026-02-13T22:01:22-07:00 (Friday)

## Issue Fixed

Error: `module 'nvim-treesitter.configs' not found`

This error occurs because nvim-treesitter 1.0+ changed its API. The old method `require("nvim-treesitter.configs").setup()` no longer works in newer versions.

## Files Modified

1. `lua/plugins/treesitter_extended.lua` - Confirmed empty (was already disabled)
2. `lua/plugins/treesitter.lua` - Updated config function to handle both old and new nvim-treesitter API

## Changes Made

In `lua/plugins/treesitter.lua`, the config function now:
- First tries the old API: `require("nvim-treesitter.configs").setup(opts)`
- Falls back to new API: `require("nvim-treesitter").setup(opts)`

## To Restore

Revert `lua/plugins/treesitter.lua` config function to use only the old API:

```lua
config = function(_, opts)
  pcall(function()
    if vim.g.base46_cache and type(vim.g.base46_cache) == "string" then
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
    end
  end)
  require("nvim-treesitter.configs").setup(opts)
end,
```
