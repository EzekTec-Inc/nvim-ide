# Restore Point: Pre-Treesitter Fix

**Date:** 2026-02-13T22:00:47-07:00 (Friday)

## Issue Fixed

Error: `Failed to run config for nvim-treesitter-textobjects`
- Module 'nvim-treesitter.configs' not found in treesitter_extended.lua

## Files Modified

### lua/plugins/treesitter_extended.lua

Changed from a disabled plugin spec that still had config references to a completely empty return.

## How to Restore

If you need to restore the previous state:

```bash
# Restore treesitter_extended.lua to previous state
cat > ~/.config/nvim/lua/plugins/treesitter_extended.lua << 'EOF'
-- This file is intentionally disabled.
-- Treesitter textobjects configuration is handled in lua/plugins/treesitter.lua
-- 
-- Restore point: 2026-02-13
-- See lua/restore_points/2026-02-13_pre_treesitter_fix.md for details.
--
-- Returning false tells Lazy.nvim to skip this plugin spec entirely.
return false
EOF
```

## Root Cause

The `treesitter_extended.lua` file was returning `false` but Lazy.nvim was still attempting to process it as a dependency configuration. The fix ensures the file returns an empty table `{}` which is a valid but empty plugin spec.
