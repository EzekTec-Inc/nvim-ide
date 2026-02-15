# Restore Point: Telescope NvChad Themes Keymap Hardening

**Date:** 2026-02-15T12:48:31-07:00 (Sunday)

## Goal

Make the NvChad themes picker entrypoint reliable when triggered from mappings, ensure it loads without errors or warnings, and ensure it opens the NvChad themes list (not Telescope layout themes) when available.

## Change Applied

Updated `lua/mappings.lua` for `<leader>th`:

- Apply the Treesitter `ft_to_lang` shim (if present) before opening Telescope pickers.
- If `_G._nvchad_open_themes_picker` is not defined yet, attempt `require("chadrc")` to initialize it.
- Prefer calling `_G._nvchad_open_themes_picker()` for the NvChad themes picker.
- Fall back to `:Telescope themes` only if the global picker is still unavailable.

## Files Modified

- `lua/mappings.lua`

## How To Restore

Revert just the mapping change in `lua/mappings.lua` by restoring the previous `<leader>th` mapping block to:

```lua
map("n", "<leader>th", function()
  if type(_G._nvchad_open_themes_picker) == "function" then
    _G._nvchad_open_themes_picker()
  else
    pcall(vim.cmd, "Telescope themes")
  end
end, { desc = "telescope nvchad themes" })
```

Or use git, if this restore point was committed:

```bash
git checkout HEAD~1 -- lua/mappings.lua
```

## Verification Checklist

1. Restart Neovim.
2. Run `:Lazy sync` if needed.
3. Press `<leader>th`.
4. Confirm:
   - no errors or warnings are printed
   - the picker shows NvChad theme names
   - selecting a theme applies it correctly
