# NVim Migration Plan - 2026-02-13

## Overview
Migrate missing plugins and mappings from `~/.config/nvim-jan-2026-working.bak/` to current nvim configuration.

## Phase 1: Create Restore Point
- [x] Create backup of current configuration files

## Phase 2: Add Missing Plugins (Priority: High)
- [ ] bigfile.nvim - Performance for large files
- [ ] cloak.nvim - Hide sensitive data
- [ ] vim-illuminate - Word highlighting
- [ ] inlay-hints.nvim - LSP inlay hints
- [ ] lspsaga.nvim - Enhanced LSP UI
- [ ] rustaceanvim - Enhanced Rust support
- [ ] harpoon - Quick file navigation
- [ ] todo-comments.nvim - TODO highlighting
- [ ] trouble.nvim - Better diagnostics
- [ ] crates.nvim - Rust crates integration

## Phase 3: Add Missing Plugins (Priority: Medium)
- [ ] legendary.nvim + duplicate.nvim - Command palette
- [ ] neovim-session-manager - Session management
- [ ] zen-mode.nvim - Focus mode
- [ ] treesj - Split/Join code
- [ ] alternate-toggler - Toggle values
- [ ] pretty-fold.nvim - Better folds
- [ ] action-hints.nvim - LSP hints

## Phase 4: Add Missing Plugins (Priority: Low)
- [ ] lspkind.nvim - Completion icons
- [ ] lsp-progress.nvim - Progress indicator
- [ ] carbon-now.nvim - Code screenshots
- [ ] tailwind-tools - Tailwind support
- [ ] Additional colorschemes

## Phase 5: Mappings Migration
- [ ] Toggle highlight line
- [ ] Terminal integrations (lazygit, node, python)
- [ ] Move lines (Alt+j/k)
- [ ] Harpoon mappings
- [ ] Enhanced yank/paste
- [ ] Plugin management shortcuts

## Phase 6: Enhanced Treesitter Config
- [ ] Add textobjects
- [ ] Add autotag
- [ ] Add context-commentstring

## Restore Instructions
To restore to previous state, copy files from:
`~/.config/nvim/.restore/2026-02-13/`
