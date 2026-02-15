# Restore Point: Telescope NvChad Themes Fix

**Date:** 2026-02-15T12:08:06-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker (triggered via `:Telescope themes`, and used by NvChad UI like the dashboard button) loads cleanly, shows the correct NvChad themes list, and applies themes without errors or warnings.

## Problem Observed

`Telescope themes` can resolve to Telescope's builtin `themes` picker (layout themes) instead of NvChad's themes picker, and theme picker flows can also be impacted when `vim.treesitter.language.ft_to_lang` is missing during preview-related code paths.

## Fix Applied

1. **Harden `ft_to_lang` shim accessibility**
   - `init.lua`: after creating the `vim.treesitter.language` proxy, explicitly stores `ft_to_lang` on the proxy table via `rawset(...)`.
   - Adds `LazyDone` and `VimEnter` safety re-application that `rawset`s `ft_to_lang` if any plugin replaces `vim.treesitter.language`.

2. **Force `:Telescope themes` to open NvChad theme picker**
   - `init.lua` and `lua/plugins/init.lua`: after loading Telescope extensions, overwrite `telescope.builtin.themes` with `telescope.extensions.themes.themes` when available.
   - This ensures the existing `Telescope themes` entrypoint invokes the NvChad themes picker.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## To Restore Previous State

Use git to revert the last changes:

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad theme names (not Telescope layout themes like dropdown/ivy).
   - Selecting a theme applies it immediately and the UI looks correct.
