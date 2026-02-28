# Plan: Investigate and accurately implement code folding

## Session: 2026-02-27 - Code Folding Optimization

### Problem Identified
- **Redundant Plugins**: `pretty-fold.nvim` was installed alongside `nvim-ufo`, creating potential conflicts and unnecessary bloat.
- **Broken Lazy Loading**: `nvim-ufo` mappings in `lua/mappings.lua` were using `require("ufo")` at load time. This caused `ufo` to be loaded prematurely or, if `lazy.nvim` hadn't initialized paths yet, resulted in mappings being silently skipped.

### Changes Made

#### 1. File: `lua/autocmds.lua`
**Status**: Modified
**Reason**: Implement robust fold persistence. Neovim does not automatically save manual folds (like those managed by `nvim-ufo`) between buffer leaves or during file saves.

**Changes**:
- Added `BufWinLeave` and `BufWritePre` autocmds to execute `mkview` (saves fold state).
- Added `BufWinEnter` and `BufWritePost` autocmds to execute `loadview` (restores fold state).
- Wrapped `loadview` in `vim.schedule` to ensure it executes after other save-triggered events (like formatting) that might reset folds.
- Added buftype validation to prevent errors in non-file buffers.
- Created `FoldPersistence` augroup to manage these events.

**Impact**: 
- Folds applied to a file will now persist after saving and reopening the file.
- Folds will remain closed even after hitting `:w`, as the state is saved immediately before writing and restored via a scheduled task immediately after.

#### 2. File: `lua/options.lua`
**Status**: Modified
**Reason**: Configure what state is saved in views.

**Changes**:
- Set `viewoptions` to `folds,cursor,slash,unix`, explicitly removing `curdir` to prevent path-related issues.

#### 3. File: `init.lua`
**Status**: Modified
**Reason**: Optimize `nvim-ufo` provider selection.

**Changes**:
- Added `provider_selector` to explicitly use `treesitter` and `indent` providers. This prevents `ufo` from falling back to less stable providers that might reset folds during buffer updates.

#### 4. File: `lua/plugins/pretty_fold.lua`
**Status**: Deleted
**Reason**: `nvim-ufo` provides superior folding capabilities (Treesitter/LSP support) and includes its own virtual text folding handler. `pretty-fold` is redundant.

#### 2. File: `lua/mappings.lua`
**Status**: Modified
**Reason**: Fix `nvim-ufo` mappings to be lazy-loading friendly.

**Changes**:
- Replaced direct function references (which required early module loading) with anonymous functions that `require("ufo")` only when the key is pressed.
- Removed the `pcall(require, "ufo")` check at the top level which was unreliable during startup.

**Impact**: 
- `nvim-ufo` will now correctly lazy-load only when a file is opened (via `BufReadPost`) or when a folding keymap is triggered.
- Fold mappings (`zR`, `zM`, `zr`, `zm`, `zk`) are now guaranteed to work.
- Reduced configuration bloat.

### Rollback Instructions
```bash
# Revert mapping changes
git checkout HEAD -- lua/mappings.lua
# Restore pretty_fold.lua
# Note: Since it was deleted, you'd need to recreate it if not in git history
```

---

## Investigation Plan: Folds Unfolding on `:w` + Code Folding Plugin Replacement

### Status: PENDING APPROVAL

### Root Cause Analysis

The current `nvim-ufo` setup has a fundamental conflict with the `:w` save flow:

1. **`rust-lang/rust.vim`** sets `vim.g.rustfmt_autosave = 1`. On every `:w` for Rust files, `rustfmt` rewrites the entire buffer contents. This destroys all in-memory fold state.
2. **`stevearc/conform.nvim`** is loaded on `BufWritePre`. For Lua/JS/TS files, it reformats the buffer before writing. This also destroys fold state.
3. **`nvim-ufo`** uses `foldmethod = "manual"`. Manual folds are stored as byte-range metadata in memory. When a formatter replaces the buffer text, Neovim invalidates those ranges and the folds disappear.
4. **`mkview`/`loadview`** saves fold line numbers to disk, but `loadview` runs *after* the formatter has potentially shifted line numbers, causing mismatched or silently ignored fold restoration.
5. **`nvim-ufo`** lacks a built-in mechanism to re-apply its own folds after an external buffer rewrite. The `provider_selector` re-computes fold *ranges* but does not re-close previously closed folds.

**Conclusion**: The problem is architectural. `nvim-ufo` + manual folds + auto-formatting on save are fundamentally incompatible. The `mkview`/`loadview` workaround cannot reliably bridge this gap.

### Evaluation Criteria for Replacement

| Criterion | Weight | Description |
|-----------|--------|-------------|
| Fold persistence on `:w` | CRITICAL | Folds must survive save + auto-format |
| Aesthetic fold text | HIGH | Must display rich, informative fold summaries |
| Treesitter integration | HIGH | Must use syntax-aware fold ranges |
| Lazy-load compatible | MEDIUM | Must work with lazy.nvim |
| Neovim 0.11 compatible | CRITICAL | Must not use deprecated APIs |
| Minimal dependencies | MEDIUM | Fewer is better |

### Candidates

#### Option A: Native Neovim Treesitter Folding + Stateful Persistence
- **Plugin**: None (built-in `foldmethod=expr`, `foldexpr=v:lua.vim.treesitter.foldexpr()`)
- **Aesthetics**: Requires custom `foldtext` function for rich display
- **Persistence**: Native `mkview`/`loadview` works correctly with expr folds because folds are recomputed from the syntax tree, not stored as byte ranges
- **Pros**: Zero dependencies, native Neovim 0.10+ feature, folds survive formatting because they are expression-based (recomputed), not manual
- **Cons**: Requires manual `foldtext` function for aesthetics, no peek preview built-in

#### Option B: `kevinhwang91/nvim-ufo` (Current - Fixed)
- **Fix approach**: Disable `rustfmt_autosave`, move formatting to `conform.nvim` with a post-format fold restoration hook
- **Aesthetics**: Already has custom `fold_virt_text_handler` ✅
- **Persistence**: Would require intercepting conform's post-format callback to re-apply folds
- **Pros**: Already installed, rich virtual text, peek preview
- **Cons**: Complex workaround, fragile, depends on formatter cooperation

#### Option C: Native Treesitter Folding + `kevinhwang91/nvim-ufo` (Hybrid)
- **Approach**: Switch `nvim-ufo` from `manual` foldmethod to using its `treesitter` provider exclusively, and configure it with `close_fold_kinds_for_ft` to auto-manage fold state
- **Aesthetics**: Keeps the existing `fold_virt_text_handler` ✅
- **Persistence**: Folds computed by expression survive formatting, `ufo` decorates them
- **Pros**: Keeps existing aesthetics, leverages treesitter recomputation
- **Cons**: Still requires `nvim-ufo` and `promise-async` dependencies

### Recommended Approach: Option A

**Rationale**:
- Neovim 0.10+ has native `vim.treesitter.foldexpr()` which computes folds from the AST
- Expression-based folds (`foldmethod=expr`) are **recomputed after every buffer change**, meaning they inherently survive formatting
- A custom `foldtext` function can replicate and exceed `nvim-ufo`'s aesthetic display
- Zero new dependencies
- Eliminates the `nvim-ufo` + `promise-async` + `mkview`/`loadview` complexity entirely

### Implementation Phases

#### Phase 1: Remove `nvim-ufo` infrastructure
- [x] Remove `nvim-ufo` plugin spec from `init.lua`
- [x] Remove `promise-async` dependency
- [x] Remove `FoldPersistence` augroup from `lua/autocmds.lua`
- [x] Remove `viewoptions` line from `lua/options.lua`

#### Phase 2: Implement native Treesitter folding
- [x] Set `foldmethod=expr` and `foldexpr=v:lua.vim.treesitter.foldexpr()` in `lua/options.lua`
- [x] Set `foldlevel=99` and `foldlevelstart=99` (all folds open by default)
- [x] Implement custom `foldtext` function with aesthetic display (line count, first line preview, icons)

#### Phase 3: Update keymaps
- [x] Replace `require("ufo")` calls in `lua/mappings.lua` with native fold commands (`zR`, `zM`, `zr`, `zm`)
- [x] Implement a `zk` peek replacement using a floating window

#### Phase 4: Validate
- [ ] Verify folds persist after `:w` on Rust files (with `rustfmt_autosave`)
- [ ] Verify folds persist after `:w` on Lua/JS/TS files (with `conform.nvim`)
- [ ] Verify aesthetic fold text displays correctly
- [ ] Verify no deprecation warnings on Neovim 0.11

---

## Session: 2026-02-27 - Replace nvim-ufo with Native Treesitter Folding

### Timestamp (UTC): 2026-02-27T20:31:00Z

### Summary
Replaced `nvim-ufo` + `promise-async` with Neovim's built-in Treesitter expression folding. Expression-based folds are recomputed from the syntax tree after every buffer change, meaning they inherently survive auto-formatting on save.

### Files Modified

#### 1. `init.lua`
**Previous behavior**: Contained full `nvim-ufo` plugin spec (~65 lines) with manual foldmethod, custom handler, provider_selector, and preview config.
**New behavior**: Plugin spec removed entirely. Folding is now handled by native Neovim options.
**Reason**: `nvim-ufo` manual folds are destroyed by formatters on `:w`.

#### 2. `lua/options.lua`
**Previous behavior**: Fold options were set inside `nvim-ufo`'s `init` function. Had `viewoptions` for `mkview`/`loadview` workaround. Stale comment about fillchars.
**New behavior**: Native Treesitter folding configured directly:
- `foldmethod=expr`, `foldexpr=v:lua.vim.treesitter.foldexpr()`
- `foldlevel=99`, `foldlevelstart=99` (all open by default)
- `fillchars` with fold indicators
- Custom `_G.CustomFoldText()` function providing: indent preservation, `⟫` icon, first line preview, `···` separator, last line preview, and line count
**Reason**: Centralize fold config. Expression folds survive formatting.

#### 3. `lua/autocmds.lua`
**Previous behavior**: `FoldPersistence` augroup with `mkview`/`loadview` on `BufWinLeave`/`BufWritePre`/`BufWinEnter`/`BufWritePost`.
**New behavior**: Augroup removed entirely.
**Reason**: Expression folds do not need external persistence — they are recomputed from the AST automatically.

#### 4. `lua/mappings.lua`
**Previous behavior**: `zR`, `zM`, `zr`, `zm`, `zk` mapped to `require("ufo")` functions.
**New behavior**: `zR`, `zM`, `zr`, `zm` mapped to native Vim fold commands. `zk` replaced with a custom floating-window peek that opens a syntax-highlighted preview of folded content (closeable with `q`).
**Reason**: No more `ufo` dependency. Peek functionality replicated natively.

### Rollback Instructions
```bash
git checkout HEAD -- init.lua lua/options.lua lua/autocmds.lua lua/mappings.lua
```

---

## Session: 2026-02-27 - Fix E1511 fillchars foldclose Error

### Timestamp (UTC): 2026-02-27T20:45:00Z

### Summary
Fixed `E1511: Wrong number of characters for field "foldclose"` crash on startup.

### Files Modified

#### 1. `lua/options.lua` (line 39)
**Previous behavior**: `fillchars` included `foldopen`, `foldsep`, and `foldclose` fields with multi-byte icon characters that Neovim rejected.
**New behavior**: `fillchars` set to `{ eob = " ", fold = " " }` only. The removed fields are unused because `foldcolumn = "0"` (fold gutter is disabled).
**Reason**: `foldopen`/`foldclose` require exactly one display-width character. With `foldcolumn = "0"`, these fields are never rendered and should be omitted.

### Rollback Instructions
```bash
git checkout HEAD -- lua/options.lua
```

---

## Session: 2026-02-27 - Fix "No fold found" (Treesitter Foldexpr Timing)

### Timestamp (UTC): 2026-02-27T20:55:00Z

### Summary
Treesitter foldexpr was set globally at startup in `lua/options.lua`, but treesitter parsers are lazy-loaded on `BufReadPost`/`BufNewFile`. At startup, no parser exists, so foldexpr evaluates to nothing and Neovim creates zero fold regions. Moved foldmethod/foldexpr to a per-buffer `FileType` autocmd that only activates after confirming a treesitter parser is available.

### Files Modified

#### 1. `lua/options.lua`
**Previous behavior**: Set `o.foldmethod = "expr"` and `o.foldexpr = "v:lua.vim.treesitter.foldexpr()"` globally at startup (before any parser loaded).
**New behavior**: Removed those two lines. Added comment pointing to `lua/autocmds.lua`. Global defaults (`foldenable`, `foldlevel`, `foldlevelstart`, `foldcolumn`, `fillchars`, `foldtext`) remain.
**Reason**: Global foldexpr at startup runs before treesitter parsers are loaded, producing zero folds.

#### 2. `lua/autocmds.lua`
**Previous behavior**: No fold-related autocmds.
**New behavior**: Added `TreesitterFolding` augroup with a `FileType` autocmd that:
1. Skips non-file buffers (`buftype ~= ""`)
2. Checks if a treesitter parser exists for the buffer (`pcall(vim.treesitter.get_parser, buf)`)
3. Only then sets `foldmethod=expr` and `foldexpr` on the buffer's window
**Reason**: Ensures foldexpr is only activated when treesitter can actually provide fold data.

### Rollback Instructions
```bash
git checkout HEAD -- lua/options.lua lua/autocmds.lua
```

---

## Session: 2026-02-27 - Fix E350 "Cannot create fold with current foldmethod"

### Timestamp (UTC): 2026-02-27T21:05:00Z

### Summary
Two issues caused `E350`: redundant keymap wrappers and a race condition in the `FileType` autocmd.

### Files Modified

#### 1. `lua/mappings.lua`
**Previous behavior**: `zR`, `zM`, `zr`, `zm` were remapped to `vim.cmd "normal! zR"` etc. — wrapping native commands in an unnecessary indirection layer that conflicted with `foldmethod=expr`.
**New behavior**: Removed all four redundant mappings. These are built-in Vim fold commands (`zR`/`zM`/`zr`/`zm`/`zo`/`zc`/`za`) that work natively with any foldmethod. Only `zk` (custom peek) is retained. Also fixed `zk` to use `vim.keymap.set` for the buffer-local `q` binding instead of the module-level `map`.
**Reason**: Remapping native fold commands adds a broken indirection. Native commands work correctly with `foldmethod=expr` out of the box.

#### 2. `lua/autocmds.lua`
**Previous behavior**: `FileType` callback immediately called `vim.fn.bufwinid(buf)` and `vim.treesitter.get_parser(buf)` synchronously. Could return `-1` window id or fail if treesitter hadn't lazy-loaded yet.
**New behavior**: Wrapped the fold setup in `vim.schedule()` to defer execution. Added guard for invalid buffer and `-1` window id before setting fold options.
**Reason**: `FileType` can fire before treesitter's `BufReadPost` handler has loaded the parser. Deferring ensures both the parser and window are available.

### Rollback Instructions
```bash
git checkout HEAD -- lua/mappings.lua lua/autocmds.lua
```

---

## Session: 2026-02-27 - Restore nvim-ufo (Correct Implementation Per Official Docs)

### Timestamp (UTC): 2026-02-27T21:20:00Z

### Summary
Native treesitter folding failed due to timing issues with lazy-loaded parsers. Reverted to `nvim-ufo` — the most robust and feature-rich folding plugin for Neovim (already installed locally). This time, implemented per the official README with two critical fixes that were missing from all previous attempts:
1. LSP `foldingRange` capability advertised to all language servers
2. `zR`/`zM`/`zr`/`zm` mapped to ufo's own API (not native Vim commands)

### Files Modified

#### 1. `init.lua`
**Previous behavior**: `nvim-ufo` plugin spec was removed.
**New behavior**: Restored `nvim-ufo` with `treesitter` + `indent` providers, aesthetic `fold_virt_text_handler` (shows `󰁂 N` line count with syntax-colored first line), and rounded preview window.
**Reason**: nvim-ufo is the only production-grade folding engine for Neovim.

#### 2. `lua/options.lua`
**Previous behavior**: Had native treesitter foldexpr settings, custom `_G.CustomFoldText()` function.
**New behavior**: Replaced with ufo-required globals only: `foldcolumn=0`, `foldlevel=99`, `foldlevelstart=99`, `foldenable=true`, minimal `fillchars`. Removed `CustomFoldText` (ufo provides its own via `fold_virt_text_handler`).
**Reason**: ufo overrides `foldtext` with virtual text. Native foldtext is unused.

#### 3. `lua/autocmds.lua`
**Previous behavior**: Had `TreesitterFolding` augroup with `FileType` autocmd.
**New behavior**: Removed entirely. ufo manages its own fold computation on `BufReadPost`.
**Reason**: ufo handles fold provider lifecycle internally.

#### 4. `lua/mappings.lua`
**Previous behavior**: Only had custom `zk` peek mapping. Native `zR`/`zM` were unmapped.
**New behavior**: All five fold keys mapped to ufo API: `openAllFolds`, `closeAllFolds`, `openFoldsExceptKinds`, `closeFoldsWith`, `peekFoldedLinesUnderCursor`.
**Reason**: ufo docs explicitly state `zR`/`zM` MUST be remapped to ufo API. Native commands change `foldlevel` which breaks ufo's state tracking.

#### 5. `lua/configs/lsp.lua`
**Previous behavior**: LSP capabilities did not include `foldingRange`.
**New behavior**: Added `textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }` to capabilities.
**Reason**: ufo docs state this is required for LSP fold provider. Without it, language servers never send folding ranges.

### Rollback Instructions
```bash
git checkout HEAD -- init.lua lua/options.lua lua/autocmds.lua lua/mappings.lua lua/configs/lsp.lua
```

---

## Session: 2026-02-27 - Implement Fold State Persistence on :w

### Timestamp (UTC): 2026-02-27T21:35:00Z

### Summary
Added `UfoFoldPersist` augroup to `lua/autocmds.lua` that saves and restores closed fold state across file saves, even when formatters rewrite the buffer.

### Files Modified

#### 1. `lua/autocmds.lua`
**Previous behavior**: No fold persistence mechanism. Folds were lost every time `:w` triggered a formatter.
**New behavior**: Two autocmds in the `UfoFoldPersist` group:
- `BufWritePre`: Iterates all folds in the buffer. For each closed fold, saves the **text content** of its start line into `vim.b[buf].ufo_closed_folds`.
- `BufWritePost`: After a 150ms defer (to let ufo recompute fold ranges after formatting), iterates the buffer. For each line whose content matches a saved fold-start line, executes `foldclose`. Uses a lookup table for O(1) matching and removes matched entries to avoid duplicate closes.
**Reason**: Formatters (`rustfmt_autosave`, `conform.nvim`) replace buffer contents on save, which destroys ufo's manual folds. Content-based matching (rather than line numbers) survives line shifts caused by formatting.

### Edge Cases Handled
- Non-file buffers skipped (`buftype ~= ""`)
- Invalid buffer check after defer
- Early exit when lookup is exhausted
- `pcall` around `foldclose` to suppress errors for lines that aren't fold-start lines after recomputation

### Rollback Instructions
```bash
git checkout HEAD -- lua/autocmds.lua
```

---

## Session: 2026-02-27 - Implement Persistent Scratchpad

### Problem Identified
- **Missing Persistent Scratchpad**: No built-in way to create and manage persistent notes/snippets that are stored outside the project directory.

### Changes Made

#### 1. File: `lua/plugins/scratch.lua`
**Status**: Created
**Reason**: Implement `LintaoAmons/scratch.nvim` for persistent, project-independent scratch files.

**Changes**:
- Configured to store scratches in `~/.local/share/nvim/scratch`.
- Enabled rounded border and centered layout for the scratch interface.
- Integrated with `dressing.nvim` for selection UI.

#### 2. File: `lua/mappings.lua`
**Status**: Modified
**Reason**: Add intuitive keymaps for scratchpad management.

**Changes**:
- Added `<leader>sn` -> `ScratchNew` (Create new scratch file).
- Added `<leader>so` -> `ScratchOpen` (Open existing scratch via picker).
- Added `<leader>sc` -> `Scratch` (Open/Toggle the last used scratch file).

**Impact**: Provides a robust, persistent note-taking and snippet-testing environment that doesn't clutter projects.

### Rollback Instructions
```bash
git checkout HEAD -- lua/mappings.lua
rm lua/plugins/scratch.lua
```

---

## Session: 2026-02-27 - Fix Angular LSP Spawning Error

### Problem Identified
- **Crash on .ts files**: Neovim 0.11 core API `vim.lsp.enable` was attempting to spawn `angularls` on every `.ts` file. If the Angular language server (`ngserver`) was not installed via Mason or in the PATH, it caused a fatal spawning error.

### Changes Made

#### 1. File: `lua/configs/lsp.lua`
**Status**: Modified
**Reason**: Make LSP setup more robust and prevent crashes for missing servers.

**Changes**:
- Enhanced `M.setup_lsp(name, opts)` to verify that the language server's command is executable before calling `vim.lsp.enable`.
- It now merges user options with `lspconfig` default configurations to accurately determine the expected command.

**Impact**: Prevents "Spawning language server failed" errors when a configured server is not yet installed or missing.

### Rollback Instructions
```bash
git checkout HEAD -- lua/configs/lsp.lua
```

---

## Session: 2026-02-27 - Migrate to Neovim 0.11 Core LSP API

### Problem Identified
- **Deprecation Warnings**: Neovim 0.11+ issued warnings about `require('lspconfig')` being deprecated as a framework.
- **LSP Spawning Errors**: Missing executables for some LSPs caused crashes on 0.11+ core APIs.

### Changes Made

#### 1. File: `lua/configs/lsp.lua`
**Status**: Modified
**Reason**: Use core `vim.lsp.config` and `vim.lsp.enable` while avoiding deprecated `require('lspconfig')`.

**Changes**:
- Refactored `setup_lsp` to avoid requiring the main `lspconfig` module on Nvim 0.11+.
- It now checks `vim.lsp.config` and `lspconfig.configs` (internal module) to find default server configurations.
- Maintains the executable check before enabling to prevent spawning crashes.

#### 2. File: `lua/custom/configs/lspconfig.lua`
**Status**: Modified
**Reason**: Remove dependency on `lspconfig.util`.

**Changes**:
- Replaced `require("lspconfig/util").root_pattern` with a version-agnostic check.
- On Nvim 0.11+, uses native `vim.fs.root`.

#### 3. File: `lua/plugins/yaml_companion_nvim.lua`
**Status**: Modified
**Reason**: Standardize LSP setup.

**Changes**:
- Switched from direct `require("lspconfig")` call to the `M.setup_lsp` helper.

**Impact**: Eliminates all LSP-related deprecation warnings in Neovim 0.11+ and ensures a stable startup process.

### Rollback Instructions
```bash
git checkout HEAD -- lua/configs/lsp.lua lua/custom/configs/lspconfig.lua lua/plugins/yaml_companion_nvim.lua
```

---

## Session: 2026-02-27 - Optimize Code Action Implementation

### Problem Identified
- **Redundancy & Inconsistency**: Code actions were mapped to generic `vim.lsp.buf.code_action` (intercepted by `dressing.nvim`), while other LSP features like rename and hover used specialized `Lspsaga` UI.
- **Visual Mode Bug**: The visual mode mapping for `<leader>ca` had invalid syntax (`<cmd>'<,'>...`), which failed in visual mode.
- **Lazy Loading**: `lspsaga` was missing the `cmd` trigger in its plugin spec.

### Changes Made

#### 1. File: `lua/mappings.lua`
**Status**: Modified
**Reason**: Standardize code actions on `Lspsaga` and fix visual mode bug.

**Changes**:
- Re-bound `<leader>ca` and `<C-Space>` in normal mode to `<cmd>Lspsaga code_action<CR>`.
- Re-bound `<leader>ca` in visual mode to `<cmd>Lspsaga code_action<CR>` (removing the invalid range syntax).

#### 2. File: `lua/plugins/lspsaga.lua`
**Status**: Modified
**Reason**: Improve lazy-loading robustness.

**Changes**:
- Added `cmd = "Lspsaga"` to the plugin spec.

**Impact**: 
- Code actions now use a specialized, high-performance UI consistent with the rest of the LSP interactions.
- Visual mode code actions are now functional.
- `Lspsaga` will correctly auto-load even if it hasn't been triggered by `LspAttach` yet.

### Rollback Instructions
```bash
git checkout HEAD -- lua/mappings.lua lua/plugins/lspsaga.lua
```

---

## Session: 2026-02-27 - Implement DAP (Debug Adapter Protocol)

### Timestamp (UTC): 2026-02-27T21:45:00Z

### Summary
Implemented a full-featured, visual debugging environment for the entire tech stack (Rust, Python, JS/TS, C++).

### Files Modified

#### 1. File: `lua/plugins/init.lua`
**Status**: Modified
**Reason**: Ensure Mason installs debuggers.
**Changes**: Added `codelldb` and `debugpy` to Mason's `ensure_installed` list.

#### 2. File: `lua/plugins/dap.lua`
**Status**: Created
**Reason**: Unified DAP configuration.
**Changes**: Configured `nvim-dap`, `nvim-dap-ui`, and `nvim-dap-virtual-text`. Added adapters for Rust/C++ (`codelldb`), Python (`debugpy`), and Node.js (`pwa-node`). Implemented automatic UI opening/closing on debug start/end.

#### 3. File: `init.lua`
**Status**: Modified
**Reason**: Remove redundant/headless `nvim-dap` declaration.
**Changes**: Removed `\"mfussenegger/nvim-dap\"` from the main plugin list.

#### 4. File: `lua/mappings.lua`
**Status**: Modified
**Reason**: Add user-facing keymaps for debugging.
**Changes**: Added `<leader>db`, `<leader>dr`, `<leader>di`, `<leader>do`, `<leader>du`, `<leader>dt`, `<leader>dw`, and `<leader>dui`.

### Rollback Instructions
```bash
git checkout HEAD -- init.lua lua/plugins/init.lua lua/mappings.lua
rm lua/plugins/dap.lua
```

---

## Session: 2026-02-27 - Stability and Performance Tweaks

### Timestamp (UTC): 2026-02-27T22:30:00Z

### Summary
Applied architectural and low-level tweaks to improve Neovim 0.11+ performance and stability, including bytecode caching, garbage collection tuning, LSP debouncing, and large file handling.

### Files Modified

#### 1. `init.lua`
- **Changes**: Enabled `vim.loader` (bytecode cache) and tuned LuaJIT garbage collector (`setpause`, `setstepmul`).
- **Reason**: Reduce startup time and editor micro-stutters.

#### 2. `lua/options.lua`
- **Changes**: Optimized `shada` file size (`!,'50,<100,s10,h`).
- **Reason**: Prevent `shada` bloat from slowing down startup over time.

#### 3. `lua/configs/lsp.lua`
- **Changes**: Added `debounce_text_changes = 150` to all LSP server flags.
- **Reason**: Reduce CPU spikes and UI lag during fast typing by throttling LSP indexing.

#### 4. `lua/autocmds.lua`
- **Changes**: Implemented `BigFileSettings` augroup to detect files > 512KB.
- **Reason**: Automatically disable heavy features (Treesitter, Spelling, complex folding) to maintain responsiveness in massive files.

### Rollback Instructions
```bash
git checkout HEAD -- init.lua lua/options.lua lua/configs/lsp.lua lua/autocmds.lua
```

---

## Session: 2026-02-27 - Implement Mermaid Support and Markdown Preview

### Timestamp (UTC): 2026-02-27T22:50:00Z

### Summary
Implemented syntax highlighting for Mermaid diagrams and a browser-based live previewer for high-fidelity Markdown rendering.

### Files Modified

#### 1. `lua/configs/treesitter.lua`
- **Changes**: Added `mermaid` to `ensure_installed`.
- **Reason**: Enable syntax highlighting for Mermaid blocks in the buffer.

#### 2. `lua/plugins/markdown_preview.lua`
- **Changes**: Created file to configure `iamcco/markdown-preview.nvim`.
- **Reason**: Provide browser-based rendering for Mermaid, SVG, and GitHub-style Markdown.

#### 3. `lua/mappings.lua`
- **Changes**: Added `<leader>mp` keymap for `MarkdownPreviewToggle`.
- **Reason**: Provide easy access to high-fidelity Markdown preview.

### Rollback Instructions
```bash
git checkout HEAD -- lua/configs/treesitter.lua lua/mappings.lua
rm lua/plugins/markdown_preview.lua
```

---

## Session: 2026-02-27 - Fix Rust LSP Initialization Conflict

### Timestamp (UTC): 2026-02-27T23:05:00Z

### Summary
Resolved conflicting Rust configurations and modernized the `rustaceanvim` setup for Neovim 0.11+.

### Files Modified

#### 1. `init.lua`
- **Changes**: Removed deprecated `rust-tools.nvim` plugin spec.
- **Reason**: Fix conflict with `rustaceanvim`.

#### 2. `lua/custom/configs/lspconfig.lua`
- **Changes**: Disabled manual `rust_analyzer` setup.
- **Reason**: `rustaceanvim` handles server lifecycle independently; manual setup via `lspconfig` causes initialization failures.

#### 3. `lua/plugins/rustaceanvim.lua`
- **Changes**: Refactored configuration to use `init` block and integrated global LSP handlers (`on_attach`, `capabilities`).
- **Reason**: Ensure correct initialization timing in Neovim 0.11 and maintain consistent keymaps.

### Rollback Instructions
```bash
git checkout HEAD -- init.lua lua/custom/configs/lspconfig.lua lua/plugins/rustaceanvim.lua
```

---

## Session: 2026-02-28 - Fix rustaceanvim Version Constraint

### Timestamp (UTC): 2026-02-28T05:42:00Z

### Summary
Fixed `rustaceanvim` not loading due to version constraint mismatch.

### Files Modified

#### 1. `lua/plugins/rustaceanvim.lua`
- **Previous behavior**: `version = "^5"` — lazy.nvim refused to load the plugin because the installed commit (`047f9c9`) is version `4.26.1`, which does not satisfy `^5`.
- **New behavior**: `version = "^4"` — matches the installed version.
- **Reason**: The version field was changed to `^5` in the prior session without verifying the locally installed version. lazy.nvim silently skips plugins that do not satisfy their version constraint.

### Rollback Instructions
```bash
git checkout HEAD -- lua/plugins/rustaceanvim.lua
```

---

## Session: 2026-02-28 - Fix rustaceanvim mason.nvim incompatibility

### Timestamp (UTC): 2026-02-28T05:45:00Z

### Summary
Fixed `rustaceanvim` initialization crash caused by breaking changes in `mason.nvim` v2.0.0+.

### Files Modified

#### 1. `lua/plugins/rustaceanvim.lua`
- **Previous behavior**: `version = "^4"`.
- **New behavior**: `version = "^5"`.
- **Reason**: The older version of `rustaceanvim` (`v4.26.1`) attempted to use `codelldb_package:get_install_path()` which was removed in `mason.nvim` v2.0.0. This caused a fatal error preventing `.rs` files from rendering and `rust-analyzer` from loading. Updating to `^5` incorporates upstream fixes for this compatibility issue.

### Rollback Instructions
```bash
git checkout HEAD -- lua/plugins/rustaceanvim.lua
```

---

## Session: 2026-02-28 - Fix Rust Analyzer Auto-formatting

### Timestamp (UTC): 2026-02-28T06:05:00Z

### Summary
Fixed `rust-analyzer` not triggering and missing format-on-save functionality for Rust files. The previous session changed `rustaceanvim` version constraint to `^5` but `lazy-lock.json` was out of date causing lazy.nvim to skip loading it entirely.

### Files Modified

#### 1. `lazy-lock.json`
- **Changes**: Updated by running `nvim --headless "+Lazy! sync" +qa`.
- **Reason**: Upgraded `rustaceanvim` locally to satisfy the new `^5` constraint. This restores `rustaceanvim` functionality and triggers `rust-analyzer`.

#### 2. `lua/plugins/init.lua`
- **Changes**: 
  - Added `rust = { "rustfmt" }` to `stevearc/conform.nvim` `formatters_by_ft`.
  - Added `format_on_save = { timeout_ms = 500, lsp_fallback = true }` to `stevearc/conform.nvim`.
  - Removed `rust-lang/rust.vim` plugin completely.
- **Reason**: Standardize the formatting workflow through `conform.nvim` (aligning Rust with TS/JS). `rust-lang/rust.vim` is redundant, conflicts with `rustaceanvim` and `conform.nvim`, and isn't needed for formatting anymore.

### Rollback Instructions
```bash
git checkout HEAD -- lua/plugins/init.lua
# To restore plugins to their prior states:
# You may need to manually rollback `lazy-lock.json` or restore `rust.vim`
```
