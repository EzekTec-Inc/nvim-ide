# Restore Point: Telescope NvChad Themes Picker Reliability

**Date:** 2026-02-15T12:42:48-07:00 (Sunday)

## Goal

Ensure the NvChad themes picker flow works accurately and reliably, without errors or warnings, when triggered from normal keymaps and UI entrypoints.

## Fix Applied

1. **Route `<leader>th` to the NvChad themes picker entrypoint**
   - `lua/mappings.lua`: Changed `<leader>th` to call `_G._nvchad_open_themes_picker()` when available.
   - Falls back to `:Telescope themes` via `pcall` if the entrypoint is not available.

2. **Harden the themes picker entrypoint against Treesitter API compatibility issues**
   - `lua/chadrc.lua`: `_G._nvchad_open_themes_picker()` now calls `_G._apply_ft_to_lang_shim()` (via `pcall`) before loading/using Telescope.
   - This ensures the Treesitter `ft_to_lang` compatibility shim is applied right before theme picker usage.

## Files Modified

- `lua/chadrc.lua`
- `lua/mappings.lua`

## How To Restore

Use git to revert the last change:

```bash
git checkout HEAD~1 -- lua/chadrc.lua lua/mappings.lua
```

Then delete this restore point file if desired:

```bash
rm lua/restore-points/2026-02-15-telescope-nvchad-themes-fix-1242.md
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `<leader>th`
3. Confirm:
   - The picker opens cleanly.
   - No errors or warnings are printed.
   - The picker behaves as the NvChad themes picker (not Telescope layout themes).
