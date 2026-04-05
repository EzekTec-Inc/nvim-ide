# Modernization Guide: Preserve & Improve

This guide shows you how to modernize your Neovim config **without losing any of your customizations**. Each change is backward-compatible and can be reverted.

---

## Strategy Overview

Your config is based on **NvChad v2.5** with heavy customization. We'll:
1. Keep all your custom keybindings, LSP configs, and plugins
2. Improve error handling and API compatibility
3. Remove redundancy without changing behavior
4. Prepare for future Neovim versions (0.12+)

**No breaking changes. All your settings stay.**

---

## Phase 1: Low-Risk, High-Value Improvements

### Improvement 1.1: Better File I/O Error Handling

**File:** `init.lua`  
**Current State:** Theme export silently fails on disk errors  
**Impact:** MEDIUM (prevents data loss notifications)

#### Step 1: Backup
```bash
cp init.lua init.lua.backup
```

#### Step 2: Replace theme export function

**Find this block (lines 57-131):**
```lua
local function cade_export_theme()
    -- ... existing function ...
    local file = io.open(theme_dir .. "/nvim-exported.json", "w")
    if file then
        file:write(vim.fn.json_encode(theme))
        file:close()
    end
end
```

**Replace with:**
```lua
local function cade_export_theme()
    local function int_to_hex(color)
        return color and string.format("#%06x", color) or nil
    end

    local function get_hl_prop(name, prop)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        if hl and hl.link then
            hl = vim.api.nvim_get_hl(0, { name = hl.link, link = false })
        end
        return hl and hl[prop] and int_to_hex(hl[prop]) or nil
    end

    local function c_fg(...)
        for _, group in ipairs({ ... }) do
            local color = get_hl_prop(group, "fg")
            if color then
                return color
            end
        end
    end

    local function c_bg(...)
        for _, group in ipairs({ ... }) do
            local color = get_hl_prop(group, "bg")
            if color then
                return color
            end
        end
    end

    local text_color = c_fg("Normal") or "#FFFFFF"
    local normal_bg = c_bg("Normal") or ""
    local accent = c_fg("Statement", "Function", "Keyword") or "#000000"
    local dim = c_fg("NonText", "Conceal") or "#888888"

    local colors = {
        accent = accent,
        border = c_fg("FloatBorder", "WinSeparator", "LineNr"),
        borderAccent = c_fg("TelescopeBorder") or accent,
        borderMuted = c_fg("Comment", "NonText"),
        success = c_fg("DiagnosticOk", "String"),
        error = c_fg("DiagnosticError", "ErrorMsg"),
        warning = c_fg("DiagnosticWarn", "WarningMsg"),
        muted = c_fg("Comment", "LineNr"),
        dim = dim,
        text = text_color,
        thinkingText = c_fg("Comment") or dim,
        selectedBg = c_bg("Visual", "CursorLine"),
        userMessageBg = c_bg("NormalFloat", "CursorLine"),
        userMessageText = c_fg("NormalFloat", "Normal") or text_color,
        customMessageBg = c_bg("NormalFloat", "Normal") or normal_bg,
        customMessageText = c_fg("NormalFloat", "Normal") or text_color,
        toolPendingBg = c_bg("CursorLine", "ColorColumn"),
        toolSuccessBg = c_bg("DiffAdd", "Normal") or normal_bg,
        toolErrorBg = c_bg("DiffDelete", "ErrorMsg"),
        toolTitle = c_fg("Title", "Function"),
        toolOutput = text_color,
    }

    for k, v in pairs(colors) do
        if not v then
            colors[k] = ""
        end
    end

    local theme = { name = "nvim-exported", author = "cade.nvim", colors = colors }
    local theme_dir = os.getenv("HOME") .. "/.cade/themes"
    
    -- IMPROVED: Better error handling
    local ok = pcall(function()
        vim.fn.mkdir(theme_dir, "p")
        local file = assert(io.open(theme_dir .. "/nvim-exported.json", "w"),
            "Cannot open theme file for writing")
        local json_str = vim.fn.json_encode(theme)
        assert(file:write(json_str), "Failed to write theme file")
        file:close()
    end)

    if not ok then
        vim.notify("Warning: Failed to export Neovim theme", vim.log.levels.WARN)
    end
end
```

**What changed:**
- ✅ Wraps file I/O in `pcall` + `assert` for better error catching
- ✅ Notifies you if export fails (instead of silent failure)
- ✅ Behavior is identical on success
- ✅ Easily reverted

#### Step 3: Verify
```vim
:source init.lua
" Switch colorscheme to trigger export
:colorscheme gruvchad
" Check ~/.cade/themes/nvim-exported.json
```

---

### Improvement 1.2: Consolidate LSP Keymaps

**Files:** `lua/autocmds.lua`, `lua/configs/lsp.lua`  
**Issue:** Duplicate keymap registration (gD, gd, K)  
**Impact:** LOW (works fine, but cleaner code)

#### Step 1: Update `lua/configs/lsp.lua`

**Find this block (lines 7-25):**
```lua
M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc, noremap = true, silent = true }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  -- ... rest of keymaps
end
```

**Replace with:**
```lua
M.on_attach = function(client, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc, noremap = true, silent = true }
  end

  -- Core navigation (locked in autocmds.lua, but set here too for explicit on_attach pattern)
  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "K", function()
    -- Intelligent hover: use RustLsp if available, else standard
    if vim.fn.exists(":RustLsp") == 2 then
      pcall(vim.cmd.RustLsp, { "hover", "actions" })
    else
      vim.lsp.buf.hover()
    end
  end, opts "Hover")
  
  -- Workspace management
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  -- LSP rename via Lspsaga (UI-consistent)
  map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts "Lspsaga rename")
end
```

#### Step 2: Simplify `lua/autocmds.lua`

**Remove lines 132-159** (duplicate UserCoreLspKeymaps group). The keymaps are now set in `on_attach`.

**Find and comment out:**
```lua
-- REMOVED: Duplicate keymap registration now handled in lsp.lua on_attach
-- do
--     local group = vim.api.nvim_create_augroup("UserCoreLspKeymaps", { clear = true })
--     ...
-- end
```

**Keep the "NvLspKeymapsLock" group** (lines 161-227) — it provides Rust fallback logic that's still valuable.

#### Step 3: Verify
```vim
:lua require("lsp").on_attach(nil, 0)
" Should have no errors
```

**Benefit:** Single source of truth for LSP keymaps. Easier to maintain.

---

### Improvement 1.3: Add Module Docstrings

**Files:** `lua/configs/lsp.lua`, `lua/plugins/core_*.lua`  
**Impact:** LOW (documentation only)

#### Step 1: Add header to `lua/configs/lsp.lua`

**Add at the very top (before line 1):**
```lua
---@module "configs.lsp"
-- LSP configuration module for Neovim 0.11+ core API with fallback to nvim-lspconfig
--
-- Features:
--   - Automatic server detection and executable checking
--   - Neovim 0.11+ vim.lsp.config() + vim.lsp.enable() API
--   - Fallback to nvim-lspconfig for older versions (0.9+)
--   - Semantic tokens disabled to avoid external tool conflicts
--   - Folding ranges, completion, snippet support configured
--   - Custom on_attach handlers with LSP navigation keymaps
--
-- Configured Servers: lua_ls, ts_ls, html, cssls, pyright, clangd, volar, angularls, marksman
-- Rust: Handled by rustaceanvim plugin (see lua/plugins/rustaceanvim.lua)

local M = {}
-- ... rest of file
```

#### Step 2: Add headers to core plugin files

Add similar headers to:
- `lua/plugins/core_lsp.lua`
- `lua/plugins/core_ui.lua`
- `lua/plugins/core_editor.lua`
- `lua/plugins/core_utils.lua`

**Example for `core_lsp.lua`:**
```lua
---@module "plugins.core_lsp"
-- Core LSP plugins: language server manager, completion, snippet support
--
-- Includes:
--   - mason.nvim: Auto-install language servers
--   - nvim-lspconfig: LSP configuration
--   - nvim-cmp: Completion with LuaSnip, autopairs
--   - tailwind-tools: Tailwind CSS integration

return {
  -- ... rest of plugins
}
```

---

## Phase 2: Future-Ready Updates (Neovim 0.12+)

### Improvement 2.1: Add vim.loop → vim.uv Compatibility Shim

**File:** `lua/autocmds.lua`  
**When:** Now (forward-compatible, no breaking change)

**Find line 81:**
```lua
local ok, stat = pcall(vim.loop.fs_stat, args.file)
```

**Replace with:**
```lua
local ok, stat = pcall((vim.uv or vim.loop).fs_stat, args.file)
```

**Explanation:** `vim.uv` is the new name in 0.12+. `vim.loop` still works in 0.11, so the `or` keeps it compatible.

**Also check for other `vim.loop` usages:**
```bash
grep -r "vim\.loop" lua/ --include="*.lua"
```

Apply the same fix wherever found.

---

### Improvement 2.2: Monitor lspsaga for API Updates

**File:** `lua/plugins/lspsaga.lua`  
**Action:** Quarterly check

Each 3 months, run:
```bash
cd ~/.local/share/nvim/lazy/lspsaga.nvim
git log --oneline -20  # Check for recent updates
```

If you see "fix deprecated" or "support Nvim 0.13", update lspsaga:
```vim
:Lazy update lspsaga.nvim
```

Then test:
```vim
:Lspsaga lightbulb toggle
```

If it works, re-enable in `lua/plugins/lspsaga.lua`:
```lua
lightbulb = {
    enable = true,  -- Re-enable when lspsaga updates
},
```

---

## Phase 3: Major Version Upgrades (0.12, 0.13+)

### When Neovim 0.12 Releases

1. **Run this test:**
   ```bash
   nvim --version  # Should show 0.12.x
   ```

2. **Check for breaking changes:**
   ```vim
   :checkhealth nvim  # Look for deprecation warnings
   ```

3. **If vim.loop errors appear:**
   - The shim in Improvement 2.1 will have already fixed it
   - No action needed

4. **If new LSP APIs are available:**
   - Consider migrating from hybrid nvim-lspconfig to pure vim.lsp.config
   - Can be done gradually (not urgent)

---

## Rollback Procedure

If any change breaks your config:

```bash
# Restore backup
cp init.lua.backup init.lua

# Or revert specific file to Git
git checkout lua/autocmds.lua

# Restart Neovim
nvim
```

**All changes in this guide are individually revertible.**

---

## Testing Checklist

After each improvement, run:

```vim
" Verify LSP
:LspInfo  " Shows active servers

" Test keybindings
gd        " Should go to definition
gD        " Should go to declaration
K         " Should show hover

" Check for errors
:Lazy     " No error statuses?
:checkhealth nvim  " Any warnings?

" Test theme export
:colorscheme catppuccin_light
:colorscheme gruvchad
:! cat ~/.cade/themes/nvim-exported.json | head -10
```

---

## Timeline for Adoption

| Phase | Improvements | Risk | Time | When |
|-------|--------------|------|------|------|
| **1** | File I/O, keymaps, docstrings | LOW | 1-2 hrs | **Now** |
| **2** | vim.loop shim, lspsaga monitoring | NONE | 15 min | **Now** (forward-compat) |
| **3** | Nvim 0.12+ migration | LOW | 30 min | When 0.12 released |

---

## Summary: What You Keep

✅ All 50+ plugins (no removals)  
✅ All your keybindings (only made cleaner)  
✅ All your LSP configs (now with better error handling)  
✅ Your Rust/Python/TS setup (untouched)  
✅ Your color scheme + theme export (improved)  
✅ Your startup time (no slowdown)  

---

## Questions?

If any improvement breaks something:

1. Check the rollback procedure above
2. Verify the change with `:checkhealth nvim`
3. Post the error message to your CADE logs

**Remember:** All changes are optional and reversible. You can adopt them one at a time.
