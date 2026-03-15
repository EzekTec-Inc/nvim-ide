## Session: 2026-03-15T18:45:00Z - Harden nvim-ufo folding providers against treesitter fallback errors

### Summary of change
Adjusted the `nvim-ufo` provider selection logic to defensively avoid treesitter-based folding when parsers are missing or when running in special buffer types. This prevents `UfoFallbackException` and related unhandled promise rejections when `nvim-ufo` attempts to use treesitter where it cannot safely do so.

### Files modified
- `lua/plugins/nvim_ufo.lua`
- `PLAN.md`

### Exact changes

#### 1. Defensive `provider_selector` implementation
In `lua/plugins/nvim_ufo.lua`, replaced the simple provider selection with a more defensive version:

```lua
  opts = {
    -- LSP → treesitter → indent, per buffer, with defensive checks
    provider_selector = function(bufnr, filetype, buftype)
      -- Special/auxiliary buffers: fall back to indent only
      if buftype ~= "" and buftype ~= "acwrite" then
        return "indent"
      end

      -- Filetypes where treesitter is more reliable than LSP folding
      local ts_only = { "markdown", "yaml", "toml", "html", "css" }
      if vim.tbl_contains(ts_only, filetype) then
        -- If no treesitter parser is available, avoid treesitter provider entirely
        local ok = pcall(vim.treesitter.get_parser, bufnr)
        if not ok then
          return "indent"
        end
        return { "treesitter", "indent" }
      end

      -- For everything else, prefer LSP, then treesitter if a parser exists, else indent
      local has_ts = pcall(vim.treesitter.get_parser, bufnr)
      if has_ts then
        return { "lsp", "treesitter" }
      end
      return { "lsp", "indent" }
    end,
    ...
  }
```

Key behaviors:
- **Special buftypes** (e.g., quickfix, nofile, help) skip treesitter and LSP folding providers entirely and use `"indent"` only.
- For filetypes explicitly marked as `ts_only` (markdown, yaml, toml, html, css):
  - We first try `vim.treesitter.get_parser(bufnr)` via `pcall`.
  - If it fails (parser missing or treesitter not available), we fall back to `"indent"` instead of returning a treesitter provider, which is what previously caused `UfoFallbackException`.
- For all other filetypes:
  - Try to get a treesitter parser; if present, use `{ "lsp", "treesitter" }`.
  - If no treesitter parser is available, fall back to `{ "lsp", "indent" }`.

#### 2. Documentation of behavior
Added comments at the top of `lua/plugins/nvim_ufo.lua` to document:
- That treesitter folding can fail or throw `UfoFallbackException`.
- That we intentionally fall back to the `indent` provider in those cases.

### Previous behavior
- `provider_selector` unconditionally returned treesitter-based providers for certain filetypes (`ts_only`) without checking for a valid treesitter parser.
- For other filetypes, it always returned `{ "lsp", "treesitter" }` when `buftype == ""`, regardless of whether a treesitter parser existed.
- When treesitter could not provide folding ranges or when configured providers failed, `nvim-ufo` would raise `UfoFallbackException`, which surfaced as an `UnhandledPromiseRejection` in the async pipeline.

### New behavior
- Treesitter is only used as a folding provider when a parser is present and can be obtained without error.
- Special buffer types are handled via the `"indent"` provider (or LSP + indent) instead of attempting treesitter.
- In cases where neither LSP nor treesitter can safely provide folds, the configuration falls back cleanly to `"indent"` instead of exploding with `UfoFallbackException`.

### Rollback instructions
```bash
cd /home/engr-uba/.config/nvim

# Restore the previous nvim-ufo plugin configuration
git restore lua/plugins/nvim_ufo.lua

# PLAN.md is append-only by policy. To undo this entry from the working tree ONLY:
# git restore PLAN.md
```
