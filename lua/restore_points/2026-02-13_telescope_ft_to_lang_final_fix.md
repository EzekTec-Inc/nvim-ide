# Restore Point: Telescope ft_to_lang Final Fix

**Date:** 2026-02-13T23:48:06-07:00 (Friday)

## Error Fixed

```
Error executing vim.schedule lua callback: ...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:135: attempt to call field 'ft_to_lang' (a nil value)
```

## Root Cause

The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+, but Telescope's previewer utils still call it. Previous shim attempts were being overwritten during plugin loading.

## Fix Applied

Consolidated and strengthened the ft_to_lang shim in `init.lua`:

1. **Single unified shim function** - Removed duplicate/redundant shim code blocks
2. **Metatable __index protection** - The `__index` metamethod always returns the shim for `ft_to_lang`
3. **Metatable __newindex protection** - Prevents `ft_to_lang` from being set to `nil`
4. **Treesitter table protection** - Monitors if `vim.treesitter.language` is replaced and re-applies shim
5. **Using rawget/rawset** - Bypasses any potential metatable interference when reading/writing values

## Files Modified

- `init.lua` - Consolidated ft_to_lang shim code at the top of the file

## To Restore Previous State

```bash
git checkout HEAD~1 -- init.lua
```

Or manually restore the previous multi-block shim approach from the git history.

## Verification

After applying this fix:
1. Restart Neovim
2. Run `:Telescope themes` or any Telescope command with preview
3. The ft_to_lang error should no longer appear

## Technical Details

The key insight is that the shim must:
- Be applied before lazy.nvim loads any plugins
- Survive any plugin that might replace `vim.treesitter.language`
- Return a valid string even for unknown filetypes (never return nil)
- Use metatable `__index` as a fallback that cannot be bypassed
- Use metatable `__newindex` to prevent the shim from being set to nil
