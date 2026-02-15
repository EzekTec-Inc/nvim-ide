# Restore Point: Telescope NvChad Themes Picker Hardening

**Date:** 2026-02-15T12:46:48-07:00 (Sunday)

## Goal

Ensure NvChad theme picker behavior is reliable and clean:

- `:Telescope themes` should route to the NvChad themes picker (not Telescope layout themes).
- It should load without errors or warnings.
- Keep it minimal, no extra plugin bloat.

## Changes Applied

### 1. Harden `:Telescope themes` dispatch

Updated `init.lua` Telescope config to re-apply the `telescope.builtin.themes` override on the next scheduler tick, after extensions have had a chance to load.

This makes the dispatch more reliable in cases where the themes extension becomes available slightly after the initial config execution.

### 2. Ensure backwards compatible config path points to the real config

Updated `lua/custom/chadrc.lua` to `require("chadrc")` instead of returning an empty table.

This ensures that any code path that still references `custom.chadrc` receives the same config and the same themes picker entrypoint logic.

## Files Modified

- `init.lua`
- `lua/custom/chadrc.lua`

## How To Restore

Revert the last change set (if it was the most recent commit):

```bash
git checkout HEAD~1 -- init.lua lua/custom/chadrc.lua
```

Optionally delete this restore point file:

```bash
rm lua/restore-points/2026-02-15-telescope-nvchad-themes-picker-hardening.md
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - No errors or warnings are printed.
   - The picker shows NvChad theme names (not Telescope layout themes).
   - Selecting a theme applies it immediately.
