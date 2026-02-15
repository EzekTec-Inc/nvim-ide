# Restore Point - 2026-02-13T23:52:55-07:00

## Files Modified

This restore point was created before implementing missing plugins from the backup configuration at `~/.config/nvim-jan-2026-working.bak/`.

### Changes Applied

1. Added `lua/plugins/bigfile.lua` - Large file handling
2. Added `lua/plugins/cloak.lua` - Secret/env file masking
3. Added `lua/plugins/illuminate.lua` - Symbol highlighting
4. Added `lua/plugins/inlayhints.lua` - LSP inlay hints
5. Added `lua/plugins/legendary.lua` - Keybinding manager
6. Added `lua/plugins/lspsaga.lua` - Enhanced LSP UI
7. Added `lua/plugins/rustaceanvim.lua` - Enhanced Rust support
8. Added `lua/plugins/sessions.lua` - Session management
9. Added `lua/configs/utils.lua` - Utility functions

### Fix Applied 2026-02-13T22:07:32-07:00

- `lua/plugins/treesitter_extended.lua`: Fixed error "module 'nvim-treesitter.configs' not found"
  - nvim-treesitter 1.0+ removed the `configs` module entirely
  - File now returns empty table with no config function
  - Treesitter textobjects are configured in `lua/plugins/treesitter.lua` as a dependency

### Fix Applied 2026-02-13T23:15:17-07:00

- `init.lua` (nvim-ufo config): Fixed E1511 error "Wrong number of characters for field foldopen"
  - Replaced multi-byte Unicode character `󰁂` in fold handler suffix with ASCII `...`
  - Replaced multi-byte Unicode border character `─` with ASCII `-` in preview win_config
  - These fields require single-byte ASCII characters only

### Fix Applied 2026-02-13T23:52:55-07:00

- `init.lua`: Fixed Telescope ft_to_lang error "attempt to call field 'ft_to_lang' (a nil value)"
  - The `vim.treesitter.language.ft_to_lang` function was removed in Neovim 0.10+
  - Simplified the shim implementation using a proxy table approach
  - The proxy ensures ft_to_lang is always accessible even if the table is modified
  - Added LazyDone autocmd to re-apply shim after plugins load

### To Restore

To revert these changes, delete the newly created files listed above.

```bash
rm lua/plugins/bigfile.lua
rm lua/plugins/cloak.lua
rm lua/plugins/illuminate.lua
rm lua/plugins/inlayhints.lua
rm lua/plugins/legendary.lua
rm lua/plugins/lspsaga.lua
rm lua/plugins/rustaceanvim.lua
rm lua/plugins/sessions.lua
rm lua/configs/utils.lua
rm lua/restore-point-2026-02-13.md
```

To restore the nvim-ufo Unicode characters (if desired after fixing the root cause):

In `init.lua` nvim-ufo config:
- Change `(" ... %d ")` back to `(" 󰁂 %d ")`
- Change `border = { "", "-", "", "", "", "-", "", "" }` back to `border = { "", "─", "", "", "", "─", "", "" }`

### After Restore

1. Restart Neovim
2. Run `:Lazy sync` to sync plugins
3. Run `:checkhealth` to verify configuration
