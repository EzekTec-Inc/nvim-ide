# Restore Point: Telescope NvChad Themes Picker Fix (configs.telescope)

**Date:** 2026-02-15T13:05:09-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker entrypoint (`:Telescope themes` and NvChad UI theme flows) loads cleanly, works as expected, and does not emit errors or warnings.

## Root Cause

Telescope was configured with `nvchad.configs.telescope` as its opts source, which bypassed the project-local `lua/configs/telescope.lua` logic, including the early `ft_to_lang` safety assignment that is needed for reliable preview behavior in Neovim 0.10+ environments.

This could allow preview-related code paths to hit:

- `vim.treesitter.language.ft_to_lang` missing or being reset, leading to runtime errors during Telescope usage.

## Fix Applied

Updated Telescope plugin specs to use the local Telescope config:

- `init.lua`: `opts = require "configs.telescope"`
- `lua/plugins/init.lua`: `opts = require "configs.telescope"`

This ensures `lua/configs/telescope.lua` runs whenever Telescope loads, so its `ft_to_lang` fallback logic is applied consistently.

## Files Modified

- `init.lua`
- `lua/plugins/init.lua`

## To Restore Previous State

Revert the opts back to NvChad defaults:

- In `init.lua`, change:
  - `return require "configs.telescope"`
  - back to `return require "nvchad.configs.telescope"`

- In `lua/plugins/init.lua`, change:
  - `return require "configs.telescope"`
  - back to `return require "nvchad.configs.telescope"`

Or use git (if committed as a single change):

```bash
git checkout HEAD~1 -- init.lua lua/plugins/init.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker opens normally and selecting a theme applies as expected.
