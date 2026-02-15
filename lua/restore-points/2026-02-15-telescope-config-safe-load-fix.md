# Restore Point: Telescope NvChad Themes Safe Load Fix

**Date:** 2026-02-15T12:42:36-07:00 (Sunday)

## Goal

Ensure Telescope, including `:Telescope themes` (NvChad themes picker flow), loads without errors or warnings, and does not fail early during config evaluation.

## Problem Observed

The local Telescope config could error during startup or telescope initialization if:

- `vim.treesitter.language` is not a table at the moment the fallback `ft_to_lang` shim check runs.
- The base46 Telescope cache file is missing or not yet generated, causing `dofile(vim.g.base46_cache .. "telescope")` to throw.

Either error can prevent Telescope from initializing cleanly, which breaks or degrades the NvChad themes picker experience.

## Fix Applied

Updated `lua/configs/telescope.lua` to:

- Guard access to `vim.treesitter.language` before calling `rawget/rawset`.
- Load base46 Telescope highlights via `pcall(dofile, ...)`, and only when `vim.g.base46_cache` is a non-empty string.

## Files Modified

- `lua/configs/telescope.lua`

## To Restore Previous State

```bash
git checkout HEAD~1 -- lua/configs/telescope.lua
```

Or manually revert the top block back to the previous unguarded `rawget(...)` check and unconditional `dofile(...)`.
