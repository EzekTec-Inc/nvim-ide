# Restore Point: Telescope NvChad Themes, ft_to_lang shim robustness

**Date:** 2026-02-15T12:21:39-07:00 (Sunday)

## Goal

Ensure NvChad theme picker via `:Telescope themes`:

- Loads without errors or warnings.
- Uses the NvChad themes picker (not Telescope layout themes).
- Works reliably (including preview related paths).
- Stays minimal, no extra bloat.

## Problem Observed

Theme picker flows can hit Telescope previewer code paths that call `vim.treesitter.language.ft_to_lang(...)`.
If the shim returns `nil`, Telescope downstream logic can error or warn during previews.

Also, if the NvChad `themes` extension load errors, `:Telescope themes` can fall back to Telescope builtin behavior.

## Fix Applied

1. **Make `ft_to_lang` shim return a string always**
   - `init.lua`: updated `_nvim_ft_to_lang_shim` to never return `nil`.
   - Invalid or empty filetype now returns `""`.
   - `get_lang` failures or missing mappings now fall back to returning the original filetype.

2. **Harden Telescope extension loading and `:Telescope themes` routing**
   - `lua/plugins/init.lua`: load extensions using `pcall(...)`, and explicitly attempt `pcall(telescope.load_extension, "themes")`.
   - Ensure `require("telescope.builtin").themes` is set to the NvChad themes picker when available, with a fallback to `builtin.colorscheme`.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## How To Restore (Undo)

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad theme names.
   - Selecting a theme applies it immediately.
