# Restore Point: Telescope NvChad Themes Runtime Fix

**Date:** 2026-02-15T13:02:06-07:00 (Sunday)

## Goal

Make `:Telescope themes` (NvChad theme picker) load cleanly, without errors or warnings, and behave consistently.

## Problem Addressed

The themes picker can hit preview related code paths where Telescope expects `vim.treesitter.language.ft_to_lang` to exist. Even with a shim in `init.lua`, the value can be missing at the moment Telescope initializes, depending on load order and later table mutations.

## Fix Applied

Before Telescope setup runs, explicitly apply the existing global shim:

- `init.lua`, inside the Telescope plugin `config = function(_, opts) ... end`:
  - Call `_G._apply_ft_to_lang_shim()` (pcall guarded) before loading base46 Telescope highlights and before `telescope.setup(opts)`.

- `lua/plugins/init.lua`, inside the Telescope plugin `config = function(_, opts) ... end`:
  - Same call to `_G._apply_ft_to_lang_shim()` before `telescope.setup(opts)`.

This keeps the change small, avoids adding new mechanisms, and ensures the shim is in place at the most relevant time, when Telescope is initializing.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## How To Restore

To revert these changes:

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

Then restart Neovim and run:

- `:Telescope themes`

## Verification Checklist

- Restart Neovim.
- Run `:Telescope themes`.
- Confirm:
  - no errors or warnings are printed
  - the picker opens normally
  - selecting a theme applies it immediately
