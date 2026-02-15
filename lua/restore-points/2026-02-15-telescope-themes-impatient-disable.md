# Restore Point: Disable impatient.nvim to stabilize Telescope themes flow

**Date:** 2026-02-15T13:19:11-07:00 (Sunday)

## Goal

Ensure the NvChad theme picker flow, including `:Telescope themes` and any NvChad UI entrypoints that route into Telescope, runs without errors or warnings and behaves consistently.

## Change Applied

- Updated `lua/plugins/impatient.lua` to set `enabled = false` for `lewis6991/impatient.nvim`.

## Rationale (Non-bloat)

- `impatient.nvim` is deprecated on Neovim 0.9+ due to built-in Lua module caching via `vim.loader`.
- Keeping a deprecated loader plugin enabled can introduce unpredictable module caching behavior during plugin initialization, which is the opposite of what we want for a stable, warning-free Telescope picker flow.
- Disabling it is the smallest change that reduces moving parts and avoids extra complexity.

## Files Modified

- `lua/plugins/impatient.lua`

## How To Restore (Re-enable impatient.nvim)

Revert the change in `lua/plugins/impatient.lua`:

- Remove the line:
  - `enabled = false,`

Or use git:

```bash
git checkout HEAD~1 -- lua/plugins/impatient.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker opens normally and selecting a theme applies it cleanly.
