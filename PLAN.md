## Session: 2026-03-15T22:54:06Z - Stability & performance tuning (Phases 1–4)

### Summary of change
Applied targeted stability and performance improvements:
1. Guarded selected `require(...)` calls in mappings with `pcall` to avoid runtime errors when plugins are unavailable.
2. Confirmed and aligned lazy-loading for selected plugins (crates.nvim, yaml-companion, hop, harpoon, CarbonNow) with their usage in mappings.
3. Left multiple terminal backends in place but made `nvchad.term` usage robust to missing plugin; no keymap removals in this step.
4. Verified treesitter and nvim-ufo configs are already scoped and robust, requiring no functional edits.

### Files modified
- `lua/mappings.lua`
- `PLAN.md`

### Exact changes

#### 1. Guard `nvchad.term` terminal mappings with `pcall`

In `lua/mappings.lua`, replaced direct `require("nvchad.term")` calls in the terminal keymaps:

```lua
-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })
map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })
```

with a guarded pattern using `pcall`:

```lua
-- new terminals
local nvterm_ok, nvterm = pcall(require, "nvchad.term")
if nvterm_ok then
  map("n", "<leader>h", function()
    nvterm.new { pos = "sp" }
  end, { desc = "terminal new horizontal term" })
  map("n", "<leader>v", function()
    nvterm.new { pos = "vsp" }
  end, { desc = "terminal new vertical window" })

  -- toggleable
  map({ "n", "t" }, "<A-v>", function()
    nvterm.toggle { pos = "vsp", id = "vtoggleTerm" }
  end, { desc = "terminal toggleable vertical term" })
end
```

This prevents runtime errors if `nvchad.term` is not available while keeping behavior unchanged when it is.

#### 2. Guard crates.nvim mappings with `pcall`

In `lua/mappings.lua`, replaced direct crates mappings:

```lua
-- Crates.nvim
map("n", "<leader>cv", function() require("crates").show_versions_popup() end, { desc = "Crates show versions" })
map("n", "<leader>cR", function() require("crates").show_features_popup() end, { desc = "Crates show features" })
map("n", "<leader>cu", function() require("crates").update_crate() end, { desc = "Crates update" })
map("n", "<leader>cU", function() require("crates").upgrade_crate() end, { desc = "Crates upgrade" })
map("n", "<leader>cH", function() require("crates").open_homepage() end, { desc = "Crates open homepage" })
map("n", "<leader>cD", function() require("crates").open_documentation() end, { desc = "Crates open documentation" })
```

with a guarded version using a cached module reference:

```lua
-- Crates.nvim
local crates_ok, crates = pcall(require, "crates")
if crates_ok then
  map("n", "<leader>cv", function() crates.show_versions_popup() end, { desc = "Crates show versions" })
  map("n", "<leader>cR", function() crates.show_features_popup() end, { desc = "Crates show features" })
  map("n", "<leader>cu", function() crates.update_crate() end, { desc = "Crates update" })
  map("n", "<leader>cU", function() crates.upgrade_crate() end, { desc = "Crates upgrade" })
  map("n", "<leader>cH", function() crates.open_homepage() end, { desc = "Crates open homepage" })
  map("n", "<leader>cD", function() crates.open_documentation() end, { desc = "Crates open documentation" })
end
```

This ensures that if `crates.nvim` is not installed or fails to load, the keymaps are simply not defined instead of causing errors.

#### 3. Confirmed and aligned lazy-loading for crates, yaml-companion, hop, harpoon, CarbonNow

No code changes were required in the plugin specs since they already used appropriate lazy-load triggers:

- `lua/plugins/crates.lua`:
  - `event = { "BufRead Cargo.toml" }` ensures crates only loads when editing `Cargo.toml`.
- `lua/plugins/yaml_companion_nvim.lua`:
  - `ft = { "yaml", "yml" }` restricts loading to YAML buffers.
- `lua/plugins/hop.lua`:
  - `lazy = true`, `cmd = { "HopWord", ... }`, and `keys = { "<leader>hw", "<leader>hl", "<leader>hc" }` already match the configured Hop keymaps.
- `lua/plugins/harpoon.lua`:
  - `event = "VeryLazy"` defers Harpoon to a later event.
- `lua/plugins/carbon_now.lua`:
  - `lazy = true`, `cmd = "CarbonNow"` restricts load to the CarbonNow command.

These were inspected and left unchanged, as they already meet the desired lazy-loading behavior.

#### 4. Treesitter and nvim-treesitter-textobjects configuration review

In `lua/plugins/treesitter.lua`:

- `ensure_installed` already lists a curated set of languages you actively use (Lua, Rust, JSON, JS/TS, Markdown, Python, TOML, YAML, etc.), not `"all"`.
- `event = { "BufReadPost", "BufNewFile" }` defers treesitter setup until after a buffer is opened.
- `highlight.disable` uses `vim.b.large_buf` to automatically disable highlighting for large buffers.
- Textobjects are configured in a separate plugin spec (`nvim-treesitter-textobjects`) with their own lazy events.

Given this, no changes were made; the config already provides a good balance of capability and robustness.

### Previous behavior
- Direct `require("nvchad.term")` and `require("crates")` calls in mappings could raise errors if these plugins were disabled, misconfigured, or temporarily unavailable.
- Lazy-loading for crates, yaml-companion, hop, harpoon, and CarbonNow was already configured but not formally documented in PLAN.md.
- Treesitter was already configured with specific languages and large-buffer safeguards, but this behavior was not documented.

### New behavior
- Terminal mappings that depend on `nvchad.term` are only created when the module loads successfully; otherwise, they are skipped without errors.
- Crates-related keymaps are only defined when `crates.nvim` can be required successfully; missing or broken crates no longer cause runtime failures.
- Existing lazy-loading behavior for crates, yaml-companion, hop, harpoon, and CarbonNow has been verified to align with their mappings and usage.
- Treesitter configuration remains unchanged but is now explicitly documented as already robust and scoped.

### Rollback instructions
```bash
cd /home/engr-uba/.config/nvim

# Restore mappings to the previous (unguarded) state
git restore lua/mappings.lua

# PLAN.md is append-only by policy. To remove this entry from the working tree ONLY:
# git restore PLAN.md
```

## 2026-03-15 23:13:36 UTC
- Summary: Aligned plugin keymaps in lua/mappings.lua with plugin specs and which-key-visible descriptions.
- Files modified: lua/mappings.lua, PLAN.md
- Exact reason: Several plugins declared keys in their plugin specs that were missing or conflicting in lua/mappings.lua, causing inaccurate implementation and inconsistent which-key display.
- Previous behavior: YAML schema selection used a Telescope command not provided by yaml-companion; DAP step-out conflicted with DBUI toggle on <leader>du; Trouble and Neotest both used <leader>t*; Dadbod UI, Neogit, Kulala, and GrugFar plugin keys existed in plugin specs but were not mirrored in lua/mappings.lua; Treesj join used <leader>sj instead of the plugin spec key.
- New behavior: YAML schema selection calls yaml-companion directly; DAP step-out uses <leader>dO; Trouble uses <leader>x* while Neotest uses <leader>t*; Dadbod UI (<leader>du), Neogit (<leader>gn), Kulala (<leader>rq/<leader>rt), and GrugFar (<leader>sr) are now present in lua/mappings.lua; Treesj join now uses <leader>s. All affected mappings retain desc values for which-key display.
- Rollback instructions: git revert HEAD to undo this change after commit, or restore lua/mappings.lua and PLAN.md from the previous commit.

## 2026-03-15 23:22:24 UTC
- Summary: Updated the active NvChad theme to solarized_dark and recorded the resulting lazy-lock plugin revision changes.
- Files modified: lua/chadrc.lua, lazy-lock.json, PLAN.md
- Exact reason: Persist the current theme selection and commit the associated lockfile state produced by the plugin manager.
- Previous behavior: The config defaulted to bearded-arc in lua/chadrc.lua, and lazy-lock.json referenced the previously locked plugin commits.
- New behavior: The config now defaults to solarized_dark with matching theme toggles, and lazy-lock.json reflects the currently resolved plugin commit revisions.
- Rollback instructions: git revert HEAD to undo after commit, or restore lua/chadrc.lua, lazy-lock.json, and PLAN.md from the previous commit.

## 2026-03-15 23:33:53 UTC
- Summary: Committed the current src/main.rs working-tree change exactly as-is at user request.
- Files modified: src/main.rs, PLAN.md
- Exact reason: The user explicitly requested committing src/main.rs without further changes after inspection.
- Previous behavior: src/main.rs did not contain the current main function block present in the working tree.
- New behavior: src/main.rs now includes the inspected main function exactly as requested, with no corrective edits applied.
- Rollback instructions: git revert HEAD to undo after commit, or restore src/main.rs and PLAN.md from the previous commit.

## 2026-03-15 23:49:36 UTC
- Summary: Centralized the <leader>s namespace into lua/mappings.lua and removed duplicate plugin-side bindings.
- Files modified: lua/mappings.lua, lua/configs/lsp.lua, lua/plugins/treesitter.lua, lua/plugins/grug-far.lua, PLAN.md
- Exact reason: Ensure <leader>s mappings are housed in lua/mappings.lua as requested and eliminate verified collisions/hidden mappings.
- Previous behavior: <leader>sh, <leader>sa, and <leader>sA were defined outside lua/mappings.lua, and <leader>sr plus <leader>sw had duplicate/conflicting definitions.
- New behavior: The <leader>s namespace is defined from lua/mappings.lua, with <leader>sw no longer conflicting with Hop and plugin-side duplicate <leader>sr registration removed.
- Rollback instructions: git revert HEAD to undo after commit, or restore the listed files from the previous commit.

## 2026-03-16 00:08:25 UTC
- Summary: Updated the active NvChad theme to ayu_dark.
- Files modified: lua/chadrc.lua, PLAN.md
- Exact reason: User manually updated the theme selection to ayu_dark in the working tree.
- Previous behavior: The config defaulted to solarized_dark in lua/chadrc.lua.
- New behavior: The config now defaults to ayu_dark with matching theme toggles.
- Rollback instructions: git revert HEAD to undo after commit, or restore lua/chadrc.lua and PLAN.md from the previous commit.

---

## Session: 2026-04-04T16:00:00Z — Theme switch: bearded-arc → gruvchad

### Summary of change
Committed unstaged theme change in `lua/chadrc.lua`. Switched default theme from `bearded-arc` to `gruvchad` across all relevant fields.

### Files modified
- `lua/chadrc.lua`
- `PLAN.md`

### Exact changes
- `base46.theme`: `"bearded-arc"` → `"gruvchad"`
- `base46.theme_toggle[1]`: `"bearded-arc"` → `"gruvchad"`
- `ui.theme`: `"bearded-arc"` → `"gruvchad"`
- `ui.theme_toggle[1]`: `"bearded-arc"` → `"gruvchad"`
- Comment block updated to match

### Reason
User requested commit of existing unstaged change.

### Previous behavior → New behavior
- Previous: Neovim started with `bearded-arc` theme; toggle cycled bearded-arc ↔ catppuccin_light
- New: Neovim starts with `gruvchad`; toggle cycles gruvchad ↔ catppuccin_light

### Rollback
```bash
git revert 3e8ec5b
```

---

## Session: 2026-04-04T17:00:00Z — Deprecation & error-handling fixes (3 items)

### Fix 1 — vim.loop → vim.uv compat shim
- **Files:** `init.lua:16`, `lua/autocmds.lua:81`, `lua/chadrc.lua:36`
- **Change:** `vim.loop.fs_stat` → `(vim.uv or vim.loop).fs_stat`
- **Reason:** `vim.loop` deprecated; breaks on Neovim 0.12+
- **Rollback:** `git revert 2f20339`

### Fix 2 — client.supports_method → capability table check
- **Files:** `lua/configs/lsp.lua:34`
- **Change:** `client.supports_method "textDocument/semanticTokens"` → `client.server_capabilities and client.server_capabilities.semanticTokensProvider`
- **Reason:** `client.supports_method` removed in Neovim 0.13
- **Rollback:** `git revert a744d27`

### Fix 3 — io.open error handling
- **Files:** `init.lua:126-133`
- **Change:** Wrapped file write in `pcall` + `assert`; added `vim.notify` on failure
- **Reason:** Silent failures on disk full / permission errors
- **Rollback:** `git revert 46dcde6`

---

## Session: 2026-04-04T18:20:00Z — Commit analysis docs

### Files modified
- `CODE_REVIEW.md`, `INDEX.md`, `MODERNIZATION_GUIDE.md`, `REVIEW_SUMMARY.md`, `PLAN.md`

### Summary
Committed 4 untracked analysis artifacts generated during code review session.

### Reason
User requested commit.

### Rollback
```bash
git revert 8e3c81d
```

---

## Session: 2026-04-05T15:49:00Z — Theme switch & plugin lock updates

### Files modified
- `lua/chadrc.lua`: Switched theme to `solarized_osaka`.
- `lazy-lock.json`: Auto-updated plugin lockfile.

### Rollback
```bash
git revert b2d8775
```

---

## Session: 2026-04-05T15:55:00Z — Code review resolution

### Files modified
- `lua/plugins/dap.lua`: Replaced `${workspaceRoot}` with `vim.fn.getcwd()`. Fixed Python DAP adapter to use Mason's debugpy and respect venv.
- `lua/autocmds.lua`: Removed duplicate `local autocmd` declaration.
- `lua/configs/lsp.lua`: Removed dead `-- EXAMPLE` code block.

### Rollback
```bash
git revert a63a7b4 af60189 5e24289
```

---

## Session: 2026-04-05T16:55:00Z — Move documentation to docs/

### Files modified
- Renamed `CODE_REVIEW.md`, `INDEX.md`, `MERMAID_SETUP.md`, `MODERNIZATION_GUIDE.md`, and `REVIEW_SUMMARY.md` to the `docs/` directory.

### Rollback
```bash
git revert af4aff6
```

---

## Session: 2026-04-05T17:15:00Z — Fix Neovim freeze and LSP loading failure

### Files modified
- `lua/plugins/nvim_surround.lua`: Removed deprecated v3 `keymaps` configuration. `nvim-surround` v4 throws an error when `keymaps` are passed to `setup()`, which broke the lazy-loading chain (`BufReadPost` -> `User FilePost`) and caused Neovim to freeze and skip LSP initialization for the first file.

### Rollback
```bash
git revert 3d63722
```

---

## Session: 2026-04-05T17:35:00Z — Cleanup and artifact management

### Files modified
- `.gitignore`: Added `.cade-todo.md` to prevent tracking tool artifacts.
- Removed test artifacts (`test.lua`, `test2.lua`, `test_freeze.lua`) from the working directory.

### Rollback
```bash
git revert 5674999
```

---

## Session: 2026-04-05T18:35:00Z — Consolidate LSP keymaps & Add module docstrings

### Files modified
- `lua/autocmds.lua`: Removed redundant `UserCoreLspKeymaps` autocommand block. Retained the `NvLspKeymapsLock` to preserve Rust `K` hover logic.
- `lua/configs/lsp.lua`: Prepended module docstring header.
- `lua/plugins/core_lsp.lua`: Prepended module docstring header.
- `lua/plugins/core_ui.lua`: Prepended module docstring header.
- `lua/plugins/core_editor.lua`: Prepended module docstring header.
- `lua/plugins/core_utils.lua`: Prepended module docstring header.

### Rollback
```bash
git revert HEAD
```

---

## Session: 2026-04-05T18:40:00Z — Update documentation status

### Files modified
- `docs/INDEX.md`: Added an update status line confirming that all Phase 1 & 2 modernization tasks and fixes have been successfully completed.

### Rollback
```bash
git revert HEAD
```
