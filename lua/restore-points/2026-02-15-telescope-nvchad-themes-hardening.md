# Restore Point: Telescope NvChad Themes Hardening

**Date:** 2026-02-15T13:01:11-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker flow (used by `:Telescope themes` routing logic and NvChad UI entrypoints like dashboard buttons) loads cleanly, produces no errors or warnings, and consistently opens the NvChad themes list.

## Changes Applied

### 1. Harden `ft_to_lang` shim application (no clobbering)

Updated `init.lua`:

- `_apply_ft_to_lang_shim()` no longer assigns `vim.treesitter = {}` or `vim.treesitter.language = {}`.
- It now:
  - `pcall(require, "vim.treesitter")` only if `vim.treesitter` is nil,
  - verifies both `vim.treesitter` and `vim.treesitter.language` are tables,
  - then `rawset`s `ft_to_lang` when possible.

This avoids any risk of overwriting Neovim's built-in treesitter module during early startup while still ensuring the shim is present for Telescope preview code paths.

### 2. Make `_G._nvchad_open_themes_picker()` load Telescope safely and quietly

Updated `lua/chadrc.lua`:

- `_G._nvchad_open_themes_picker(opts)` now:
  - normalizes `opts` to a table,
  - attempts `require("telescope")`,
  - if that fails, tries `require("lazy").load({ plugins = { "telescope.nvim" } })` and re-requires Telescope,
  - avoids calling `:Telescope themes` as a fallback (prevents mis-routing and avoids potential recursion),
  - only attempts `telescope.load_extension("themes")` if `telescope._extensions.themes` is present.

## Files Modified

- `init.lua`
- `lua/chadrc.lua`

## To Restore Previous State

Use git to revert these changes:

```bash
git checkout HEAD~1 -- init.lua lua/chadrc.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - no errors or warnings are printed,
   - the picker shows NvChad theme names (base46 themes),
   - selecting a theme applies it immediately.
