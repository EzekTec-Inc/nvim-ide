# Engr-Uba's NvChad Neovim Configuration

This repository contains a highly optimized and modern Neovim configuration based on **NvChad**, specifically tailored for **Neovim 0.11+**. It features deep integration with the latest core LSP APIs and provides a seamless development experience for **Rust**, **Python**, **C++**, and the **MERN stack**.

## 🚀 Key Features

- **Neovim 0.11 Core LSP API:** Migrated from `nvim-lspconfig` framework to the native `vim.lsp.config` and `vim.lsp.enable` APIs for better performance and future-proofing.
- **Advanced Language Support:** Full LSP, formatting, and linting support for:
  - **Rust:** `rust-analyzer` + `crates.nvim` + `rstml`
  - **JavaScript/TypeScript:** `ts_ls` + `prettier` + `tailwind-tools`
  - **Python:** `pyright` + `venv-selector`
  - **C++:** `clangd`
  - **Web:** `html`, `cssls`, `volar` (Vue), `angularls` (Angular)
- **Modern UI:** Enhanced with `lspsaga.nvim`, `trouble.nvim`, `dressing.nvim`, and `noice.nvim` (via NvChad).
- **Productivity Boosters:** Harpoon, Hop navigation, ToggleTerm, and Lazygit integration.
- **CADE IDE Bridge:** Live two-way integration with the CADE agent via `cade-ide-mcp`. The agent reads open buffers, active file, selection, diagnostics, and workspace folders — and can apply edits, open files, run terminals/tasks, and drive `nvim-dap` directly from chat.

## 🛠 Installation

To use this configuration, clone this repository into your Neovim configuration directory:

```sh
git clone https://github.com/EzekTec-Inc/nvim.git ~/.config/nvim
```

## ⌨️ Keymaps

### General
| Key | Action |
| --- | --- |
| `;` | Enter Command Mode |
| `jj` | Escape Insert Mode |
| `<leader>n` | Toggle Line Numbers |
| `<leader>rn` | Toggle Relative Numbers |
| `<leader>ha` | Toggle Line Highlight |
| `<leader>uh` | Toggle Inlay Hints |
| `<leader>z` | Toggle Zen Mode |

### LSP & Diagnostics
| Key | Action |
| --- | --- |
| `gd` | Go to Definition |
| `gr` | Show References |
| `K` / `<C-k>` | Hover Info (Lspsaga) |
| `<leader>ca` | Code Action |
| `<leader>cr` | Rename (Lspsaga) |
| `<leader>cd` | Line Diagnostics |
| `]t` / `[t` | Next/Prev TODO comment |

### Rust / Crates.nvim
| Key | Action |
| --- | --- |
| `<leader>cv` | Show Crate Versions |
| `<leader>cR` | Show Crate Features |
| `<leader>cu` | Update Crate |
| `<leader>cU` | Upgrade Crate |

### Navigation & Terminals
| Key | Action |
| --- | --- |
| `s` | Hop to Word |
| `<C-a>` | Harpoon: Add file |
| `<C-e>` | Harpoon: Toggle menu |
| `<A-f>` | Toggle Floating Terminal (FTerm) |
| `<A-h>` | Toggle Horizontal Terminal (ToggleTerm) |
| `<leader>gg` | Lazygit (Floating) |

### CADE IDE Bridge
| Command | Action |
| --- | --- |
| `:CadeReconnect` | Reconnect to `cade-ide-mcp` |
| `:CadeCheckConnection` | Show connection state + current snapshot |
| `:CadeDisconnect` | Drop the bridge |

## 🔧 Recent Improvements (Apr 2026)

- **CADE IDE Integration:** Added the `cade-neovim` plugin that speaks the `cade-ide-mcp` protocol over TCP loopback. State is auto-pushed on every `BufEnter`/`CursorMoved`/`ModeChanged`/`DiagnosticChanged` (50 ms debounced).
- **Theme Export:** `cade_export_theme()` writes `~/.cade/themes/nvim-exported.json` on startup and on every `ColorScheme` change so the CADE UI mirrors your editor palette.

## 🔧 Recent Improvements (Feb 2026)

- **LSP Core Migration:** Fully migrated to `vim.lsp.config` core API for Neovim 0.11, resolving long-standing deprecation warnings.
- **Stability Fixes:** Resolved an infinite require loop caused by a shadowed `lua/lspconfig.lua` file.
- **Diagnostic Signs:** Migrated to the new `vim.diagnostic.config` signs API, eliminating warnings from `crates.nvim` and `lspsaga`.
- **Plugin Optimization:** Refactored `lspsaga` and `nvim-surround` loading sequences for faster startup.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

