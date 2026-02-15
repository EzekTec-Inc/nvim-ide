# Restore Point - 2026-02-13

This file documents the state before implementing backup plugin configurations.

## Latest Fix Applied

**2026-02-13T23:54:56-07:00:** Fixed Telescope ft_to_lang error "attempt to call field 'ft_to_lang' (a nil value)"

The error was caused by the metatable proxy approach for the ft_to_lang shim not working correctly. The proxy table was empty and when Telescope accessed `vim.treesitter.language.ft_to_lang`, it got `nil` because the `__index` metamethod wasn't being triggered properly in all cases.

**Fix:** Simplified the shim to use direct assignment instead of a metatable proxy. Added a VimEnter autocmd to re-apply the shim if it gets overwritten during plugin loading.

**To restore previous (metatable proxy) state:**
```lua
-- In init.lua, replace the simplified shim block with the metatable proxy approach:
-- See lua/restore-points/2026-02-13-treesitter-fix.md for the full previous implementation
```

---

**2026-02-13T23:16:30-07:00:** Fixed E1511 error "Wrong number of characters for field foldopen"

The error was caused by `lua/options.lua` setting `foldopen`, `foldsep`, and `foldclose` in `vim.opt.fillchars` to empty strings. These fields require exactly one single-byte ASCII character or must be omitted entirely.

**Fix:** Removed `foldopen`, `foldsep`, and `foldclose` from the fillchars table in `lua/options.lua`. nvim-ufo handles fold display via `fold_virt_text_handler` instead.

**To restore previous (broken) state:**
```lua
-- In lua/options.lua, change fillchars back to:
vim.opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = "",
}
```

---

**2026-02-13T22:08:05-07:00:** Fixed `lua/plugins/treesitter_extended.lua` which was causing the error:
```
module 'nvim-treesitter.configs' not found
```

The file was attempting to require `nvim-treesitter.configs` which no longer exists in nvim-treesitter 1.0+. The file now returns an empty table, as all treesitter configuration is handled in `lua/plugins/treesitter.lua`.

## Files Modified
- lua/plugins/init.lua
- lua/mappings.lua
- lua/plugins/treesitter_extended.lua (fixed 2026-02-13T22:08:05)

## Files Created
- lua/plugins/bigfile.lua
- lua/plugins/cloak.lua
- lua/plugins/illuminate.lua
- lua/plugins/inlayhints.lua
- lua/plugins/legendary.lua
- lua/plugins/lspsaga.lua
- lua/plugins/rustaceanvim.lua
- lua/plugins/sessions.lua
- lua/plugins/treesitter_enhanced.lua
- lua/plugins/ufo_enhanced.lua
- lua/configs/utils.lua

## To Restore
Delete the created files and revert modifications using git:
```sh
git checkout HEAD -- lua/plugins/init.lua lua/mappings.lua
rm -f lua/plugins/bigfile.lua lua/plugins/cloak.lua lua/plugins/illuminate.lua
rm -f lua/plugins/inlayhints.lua lua/plugins/legendary.lua lua/plugins/lspsaga.lua
rm -f lua/plugins/rustaceanvim.lua lua/plugins/sessions.lua
rm -f lua/plugins/treesitter_enhanced.lua lua/plugins/ufo_enhanced.lua
rm -f lua/configs/utils.lua
rm -f lua/restore_point_2026_02_13.md
```

## To Restore treesitter_extended.lua Fix Only
If you need to revert just the treesitter_extended.lua fix:
```sh
git checkout HEAD -- lua/plugins/treesitter_extended.lua
```
