# Restore Point: Telescope NvChad Themes Picker Fix

**Date:** 2026-02-15T12:56:41-07:00 (Sunday)

## Goal

Ensure NvChad theme picker works reliably via `:Telescope themes`:

- Loads without errors or warnings
- Shows NvChad theme list (not Telescope layout themes)
- Applies themes correctly
- No added bloat

## Fix Applied

Updated `init.lua` to:

- Keep the existing `ft_to_lang` compatibility shim behavior.
- Add a small, resilient patch that forces `telescope.builtin.themes` to route to the NvChad themes picker when available:
  - Prefer `_G._nvchad_open_themes_picker(opts)` when defined
  - Otherwise, attempt `telescope.load_extension("themes")` and call `telescope.extensions.themes.themes(opts)`
  - Fallback to `telescope.builtin.colorscheme(opts)` only if NvChad picker is unavailable

This patch is applied alongside the existing shim re-application points (immediate, deferred, `LazyDone`, and `VimEnter`).

## Files Modified

- `init.lua`

## How To Restore

Revert the latest change:

```bash
git checkout HEAD~1 -- init.lua
```

Then restart Neovim.

## Verification Steps

1. Restart Neovim.
2. Run:

```vim
:Telescope themes
```

3. Confirm:
- No errors or warnings are printed.
- The picker shows NvChad theme names (not Telescope layout themes).
- Selecting a theme applies it immediately.
