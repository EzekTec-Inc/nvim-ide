# Restore Point: Telescope NvChad Themes, activate.nvim dependency fix

**Date:** 2026-02-15T12:55:35-07:00 (Sunday)

## Goal

Make `:Telescope themes` reliably resolve to the NvChad themes picker behavior, without errors or warnings, and without adding bloat.

## Problem Observed

`lua/plugins/activate.lua` declared Telescope as a full dependency spec (with its own `branch` and `dependencies` fields). With lazy.nvim, providing a dependency as a full plugin spec can merge into the main plugin spec for Telescope, potentially clobbering or interfering with the intended Telescope configuration that enables the NvChad themes picker flow.

This can cause `:Telescope themes` to behave inconsistently (for example, resolving to Telescope's builtin layout themes picker instead of the NvChad themes picker), or introduce subtle startup warnings due to spec merging.

## Fix Applied

Updated `lua/plugins/activate.lua` to depend on Telescope using the simple string form:

- From a full nested plugin spec for `nvim-telescope/telescope.nvim`
- To: `"nvim-telescope/telescope.nvim"`

This ensures Telescope is still installed and available for activate.nvim, while avoiding any unintended Telescope spec overrides or merges.

## Files Modified

- `lua/plugins/activate.lua`

## To Restore Previous State

Revert `lua/plugins/activate.lua` back to the previous dependency table form (the nested Telescope spec), or use git to restore the previous version of the file.

```bash
git checkout HEAD~1 -- lua/plugins/activate.lua
```

## Verification Steps

1. Restart Neovim.
2. Run:
   - `:Telescope themes`
3. Confirm:
   - no errors or warnings are printed
   - the picker shows NvChad theme names (not Telescope layout themes like dropdown/ivy)
   - selecting a theme applies cleanly
