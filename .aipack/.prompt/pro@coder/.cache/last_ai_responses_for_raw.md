====
>   Info: Duration: 2m 38s | ~$0.1669 | Prompt Tokens: 63,181 (cached: 57,088) | Completion Tokens: 10,446 (reasoning: 9,400) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 73 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "^ nvim - lock lsp keymaps (gD/gd/K) and restore gk/gq in lsp buffers"
</suggested_git_command>

<AIP_FILE_CHANGE file_path="init.lua">
````lua
<<<<<<< SEARCH
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
=======
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

-- FIX 2026-02-17T13:18:55-07:00: Lock core navigation keymaps in LSP-attached buffers.
do
  local augroup = vim.api.nvim_create_augroup("NvLspKeymapsLock", { clear = true })

  local function lsp_hover()
    if vim.fn.exists(":RustLsp") == 2 then
      local ok = pcall(vim.cmd.RustLsp, { "hover", "actions" })
      if ok then
        return
      end
    end

    pcall(vim.lsp.buf.hover)
  end

  local function lock_keymaps(bufnr)
    if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
      return
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, silent = true })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, silent = true })
    vim.keymap.set("n", "K", lsp_hover, { buffer = bufnr, silent = true })

    vim.keymap.set("n", "gk", "gk", { buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set({ "n", "v" }, "gq", "gq", { buffer = bufnr, silent = true, noremap = true })
  end

  local function get_clients(bufnr)
    local fn = vim.lsp.get_clients or vim.lsp.get_active_clients
    if type(fn) ~= "function" then
      return {}
    end
    local ok, clients = pcall(fn, { bufnr = bufnr })
    if ok and type(clients) == "table" then
      return clients
    end
    return {}
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      vim.schedule(function()
        lock_keymaps(args.buf)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
        return
      end

      local clients = get_clients(bufnr)
      if #clients == 0 then
        return
      end

      vim.schedule(function()
        lock_keymaps(bufnr)
      end)
    end,
  })
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>

<AIP_FILE_CHANGE file_path="lua/configs/restore-point-2026-02-17-13-18-55.lua">
````lua
-- RESTORE POINT: 2026-02-17T13:18:55-07:00 (Tuesday)
-- This file documents the state before enforcing core LSP/navigation keymaps in LSP-attached buffers.
--
-- Change applied:
--   - init.lua: Added NvLspKeymapsLock autocmd group to re-assert buffer-local keymaps:
--       gD -> vim.lsp.buf.declaration
--       gd -> vim.lsp.buf.definition
--       K  -> LSP hover (prefers :RustLsp hover actions when available)
--       gk -> built-in display-line up
--       gq -> built-in formatter operator
--
-- To restore (if committed right after this change):
--   git checkout HEAD~1 -- init.lua lua/configs/restore-point-2026-02-17-13-18-55.lua

return {
  restore_date = "2026-02-17T13:18:55-07:00",
  description = "Before locking core LSP keymaps (gD/gd/K) and restoring default gk/gq behavior in LSP buffers",
}
````
</AIP_FILE_CHANGE>

====
>   Info: Duration: 3m 35s | ~$0.2178 | Prompt Tokens: 57,821 (cached: 52,096) | Completion Tokens: 14,188 (reasoning: 12,994) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 73 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Stabilize core lsp keymaps (gD/gd/K/gk) and preserve gq formatting"
</suggested_git_command>

<AIP_FILE_CHANGE file_path="init.lua">
````lua
<<<<<<< SEARCH
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
=======
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

-- FIX 2026-02-17T13:18:55-07:00: Stabilize core LSP keymaps (gD, gd, K, gk) and preserve gq formatting operator.
local function _nvchad_ensure_core_lsp_keymaps(bufnr, client_id)
  if type(bufnr) ~= "number" or bufnr <= 0 then
    return
  end

  local function buf_map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, { buffer = bufnr, noremap = true, silent = true, desc = desc })
  end

  buf_map("gD", vim.lsp.buf.declaration, "LSP Go to declaration")
  buf_map("gd", vim.lsp.buf.definition, "LSP Go to definition")
  buf_map("gk", vim.lsp.buf.signature_help, "LSP Show signature help")
  buf_map("K", function()
    if vim.bo[bufnr].filetype == "rust" and vim.cmd and type(vim.cmd.RustLsp) == "function" then
      local ok = pcall(vim.cmd.RustLsp, { "hover", "actions" })
      if ok then
        return
      end
    end
    pcall(vim.lsp.buf.hover)
  end, "LSP Hover")

  pcall(vim.keymap.del, "n", "gq", { buffer = bufnr })
  pcall(vim.keymap.del, "v", "gq", { buffer = bufnr })

  local client = nil
  if type(client_id) == "number" then
    client = vim.lsp.get_client_by_id(client_id)
  end

  local supports_format = false
  if client and type(client.supports_method) == "function" then
    supports_format = client.supports_method("textDocument/formatting")
      or client.supports_method("textDocument/rangeFormatting")
  end

  if supports_format and (vim.bo[bufnr].formatexpr == nil or vim.bo[bufnr].formatexpr == "") then
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
  end
end

do
  local group = vim.api.nvim_create_augroup("UserLspCoreKeymaps", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local client_id = args.data and args.data.client_id
      vim.defer_fn(function()
        _nvchad_ensure_core_lsp_keymaps(bufnr, client_id)
      end, 0)
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      local first = clients and clients[1]
      if not first then
        return
      end

      vim.defer_fn(function()
        _nvchad_ensure_core_lsp_keymaps(bufnr, first.id)
      end, 0)
    end,
  })
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>

<AIP_FILE_CHANGE file_path="lua/configs/restore-point-2026-02-17-13-18-55.lua">
````lua
-- RESTORE POINT: 2026-02-17T13:18:55-07:00 (Tuesday)
-- This file documents the state before hardening core LSP keymaps against plugin overrides.
--
-- Change applied:
--   - init.lua: Added a deferred LspAttach + BufEnter enforcement to ensure buffer-local mappings for:
--       gD -> vim.lsp.buf.declaration
--       gd -> vim.lsp.buf.definition
--       K  -> hover (Rust uses RustLsp hover actions when available)
--       gk -> vim.lsp.buf.signature_help
--     and to ensure the built-in gq formatting operator is not replaced by a buffer-local mapping.
--
-- To restore (if committed right after this change):
--   git checkout HEAD~1 -- init.lua lua/configs/restore-point-2026-02-17-13-18-55.lua

return {
  restore_date = "2026-02-17T13:18:55-07:00",
  description = "Before enforcing stable LSP keymaps on LspAttach (gD/gd/K/gk) and preserving gq operator",
}
````
</AIP_FILE_CHANGE>

====
>   Info: Duration: 6m 10s | ~$0.4476 | Prompt Tokens: 58,885 | Completion Tokens: 24,613 (reasoning: 23,483) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 73 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "^ nvim - Harden core LSP keymaps (gD, gd, K, gK)"
</suggested_git_command>

<AIP_FILE_CHANGE file_path="init.lua">
````lua
<<<<<<< SEARCH
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- FIX 2026-02-13T23:58:08: Robust ft_to_lang shim using metatable proxy
=======
vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

do
  local group = vim.api.nvim_create_augroup("UserCoreLspKeymaps", { clear = true })

  local function apply(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local function opts(desc)
      return { buffer = bufnr, desc = "LSP " .. desc, noremap = true, silent = true }
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover")
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts "Show signature help")
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      vim.schedule(function()
        apply(bufnr)
      end)
    end,
  })
end

-- FIX 2026-02-13T23:58:08: Robust ft_to_lang shim using metatable proxy
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>

<AIP_FILE_CHANGE file_path="lua/configs/lspconfig.lua">
````lua
<<<<<<< SEARCH
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
=======
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "K", vim.lsp.buf.hover, opts "Hover")
  map("n", "gK", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>

<AIP_FILE_CHANGE file_path="lua/configs/restore-point-2026-02-17-13-18-55.lua">
````lua
-- RESTORE POINT: 2026-02-17T13:18:55-07:00 (Tuesday)
-- This file documents the state before enforcing core LSP keymaps via an early LspAttach autocmd.
--
-- Change summary:
-- 1) init.lua: Added a UserCoreLspKeymaps LspAttach autocmd that re applies buffer local mappings for gD, gd, K, and gK.
-- 2) lua/configs/lspconfig.lua: Added missing K and gK mappings in M.on_attach for completeness.
--
-- How to restore:
-- git checkout HEAD~1 -- init.lua lua/configs/lspconfig.lua lua/configs/restore-point-2026-02-17-13-18-55.lua
--
-- How to verify:
-- In a buffer with an attached LSP client, run:
--   :verbose nmap <buffer> gD
--   :verbose nmap <buffer> gd
--   :verbose nmap <buffer> K
--   :verbose nmap <buffer> gK
-- They should report that the mapping was last set from init.lua.

return {
  restore_date = "2026-02-17T13:18:55-07:00",
  description = "Before enforcing core LSP keymaps (gD, gd, K, gK) via early LspAttach autocmd",
}
````
</AIP_FILE_CHANGE>

- Investigation results, from the files you provided:
  - `gD` and `gd` were only being set inside LSP `on_attach` functions, which means any LSP client that does not call your shared `on_attach` could miss them.
  - `K` was not mapped in your shared LSP mapping code, and Rust specific tooling can define its own `K` mapping.
  - I did not find any explicit mappings for `gk` or `gq` in the provided config files, so if those are changing it is likely coming from a plugin. You can confirm with `:verbose nmap gk` and `:verbose nmap gq` in the affected buffer.
- What the change does:
  - Adds an early `LspAttach` autocmd in `init.lua` that applies buffer local mappings for `gD`, `gd`, `K`, and `gK` after attach, so they win even if other code sets mappings during attach.

