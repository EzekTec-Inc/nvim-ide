====
>   Info: Duration: 2m 4s | ~$0.1412 | Prompt Tokens: 62,497 (cached: 49,920) | Completion Tokens: 7,890 (reasoning: 7,223) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 75 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Harden Telescope ft_to_lang shim to prevent nil calls"
</suggested_git_command>

- Root cause: your Telescope version still calls the removed Neovim API `vim.treesitter.language.ft_to_lang()`. Even though you set it early, at runtime that field can become `nil` again (for example, if something clears it during plugin load), so Telescope previewers crash inside a scheduled callback.
- Fix: harden the shim by installing a metatable `__index` fallback on `vim.treesitter.language`, so `ft_to_lang` always resolves to the shim even if the key is later cleared. This keeps behavior minimal and avoids adding more load order hacks.

<AIP_FILE_CHANGE file_path="init.lua">
````lua
<<<<<<< SEARCH
  if type(_G._nvim_ft_to_lang_shim) == "function" then
    rawset(lang, "ft_to_lang", _G._nvim_ft_to_lang_shim)
  end
end
=======
  if type(_G._nvim_ft_to_lang_shim) == "function" then
    rawset(lang, "ft_to_lang", _G._nvim_ft_to_lang_shim)

    local mt = getmetatable(lang) or {}
    if mt.__nvchad_ft_to_lang_shim_applied ~= true then
      local prev_index = mt.__index
      mt.__index = function(t, k)
        if k == "ft_to_lang" then
          return _G._nvim_ft_to_lang_shim
        end

        if type(prev_index) == "function" then
          return prev_index(t, k)
        elseif type(prev_index) == "table" then
          return prev_index[k]
        end
      end
      mt.__nvchad_ft_to_lang_shim_applied = true
      pcall(setmetatable, lang, mt)
    end
  end
end
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>

<AIP_FILE_CHANGE file_path="lua/configs/restore-point-2026-02-15-133449.lua">
````lua
-- RESTORE POINT: 2026-02-15T13:34:49-07:00 (Sunday)
-- This file documents the state before hardening the Treesitter ft_to_lang shim
-- used by Telescope previewers.
--
-- To restore, revert the following file to its state before this date:
--   - init.lua
--
-- Changes made:
--   1. init.lua: _apply_ft_to_lang_shim now also installs a metatable __index
--      fallback on vim.treesitter.language so ft_to_lang always resolves to the
--      shim even if cleared later during plugin load.
--
-- Git command to restore (if committed):
--   git checkout HEAD~1 -- init.lua

return {
  restore_date = "2026-02-15T13:34:49-07:00",
  description = "Before hardening Treesitter ft_to_lang shim for Telescope previewers",
}
````
</AIP_FILE_CHANGE>

====
>   Info: Duration: 3m 7s | ~$0.2405 | Prompt Tokens: 57,899 (cached: 13,952) | Completion Tokens: 11,514 (reasoning: 10,782) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 75 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Harden treesitter ft_to_lang shim for telescope previewers"
</suggested_git_command>

<AIP_FILE_CHANGE file_path="init.lua">
````lua
<<<<<<< SEARCH
  local lang = ts.language
  if type(lang) ~= "table" then
    return
  end

  if type(_G._nvim_ft_to_lang_shim) == "function" then
    rawset(lang, "ft_to_lang", _G._nvim_ft_to_lang_shim)
  end
end
=======
  local lang = ts.language
  if type(lang) ~= "table" then
    return
  end

  local shim = _G._nvim_ft_to_lang_shim
  if type(shim) ~= "function" then
    return
  end

  rawset(lang, "ft_to_lang", shim)

  local ok_mt, mt = pcall(getmetatable, lang)
  if not ok_mt then
    return
  end

  if type(mt) ~= "table" then
    mt = {}
  end

  if mt.__nvim_ft_to_lang_shim_applied ~= true then
    local prev_index = mt.__index

    mt.__index = function(t, k)
      if k == "ft_to_lang" then
        return shim
      end

      if type(prev_index) == "function" then
        return prev_index(t, k)
      end

      if type(prev_index) == "table" then
        return prev_index[k]
      end
    end

    mt.__nvim_ft_to_lang_shim_applied = true
    pcall(setmetatable, lang, mt)
  end
end
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>

<AIP_FILE_CHANGE file_path="lua/configs/restore-point-2026-02-15-13-34-49.lua">
````lua
-- RESTORE POINT: 2026-02-15T13:34:49-07:00 (Sunday)
-- This file documents the state before hardening the Treesitter ft_to_lang compatibility shim.
--
-- Error addressed:
--   Error executing vim.schedule lua callback: ...telescope/previewers/utils.lua:135:
--   attempt to call field 'ft_to_lang' (a nil value)
--
-- Root cause:
--   Neovim 0.10+ removed vim.treesitter.language.ft_to_lang, and telescope (including NvChad's
--   themes extension previewer) still calls it. The shim was being applied, but it could still
--   become nil at runtime if something clears or replaces the field later.
--
-- Fix applied:
--   - init.lua: _apply_ft_to_lang_shim now also installs a metatable fallback on
--     vim.treesitter.language, so indexing `ft_to_lang` always yields the shim even if the field
--     is cleared later.
--
-- To restore (if committed right after this change):
--   git checkout HEAD~1 -- init.lua lua/configs/restore-point-2026-02-15-13-34-49.lua

return {
  restore_date = "2026-02-15T13:34:49-07:00",
  description = "Before hardening Treesitter ft_to_lang shim for Telescope previewers",
}
````
</AIP_FILE_CHANGE>

====
>   Info: Duration: 3m 14s | ~$0.1922 | Prompt Tokens: 58,932 (cached: 56,960) | Completion Tokens: 12,769 (reasoning: 11,352) 
>  Model: gpt-5.2-high (gpt-5.2-2025-12-11) | Adapter: OpenAI
>  Files: Context Files: 75 | Working Files: 1 | Knowledge Files: 12
>   Note: write_mode is true, so content below this line will **NOT** be included in next run/prompt.

<suggested_git_command>
git add -A .
git commit -m "- nvim - Fix Telescope ft_to_lang shim persistence"
</suggested_git_command>

Root cause: Neovim 0.10 removed `vim.treesitter.language.ft_to_lang`, Telescope (and NvChad themes preview) still calls it, and the current shim can be lost when `vim.treesitter.language` is replaced or the key gets cleared later. Fix: install a small proxy for `vim.treesitter.language` that always supplies `ft_to_lang`, and ensure future `vim.treesitter.language = ...` assignments get wrapped too.


<AIP_FILE_CHANGE file_path="init.lua">
````lua
<<<<<<< SEARCH
-- Store in global for persistence
_G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim

local function _apply_ft_to_lang_shim()
  if vim.treesitter == nil then
    local ok, ts_mod = pcall(require, "vim.treesitter")
    if ok and vim.treesitter == nil then
      vim.treesitter = ts_mod
    end
  end

  local ts = vim.treesitter
  if type(ts) ~= "table" then
    return
  end

  if ts.language == nil then
    local ok, lang_mod = pcall(require, "vim.treesitter.language")
    if ok and ts.language == nil then
      ts.language = lang_mod
    end
  end

  local lang = ts.language
  if type(lang) ~= "table" then
    return
  end

  if type(_G._nvim_ft_to_lang_shim) == "function" then
    rawset(lang, "ft_to_lang", _G._nvim_ft_to_lang_shim)
  end
end
=======
-- Store in global for persistence
_G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim

local function _make_ts_language_proxy(lang)
  local proxy = {}

  local mt = {
    __nvim_ft_to_lang_proxy = true,
    __nvim_lang_actual = lang,
    __index = function(_, k)
      if k == "ft_to_lang" then
        local existing = rawget(lang, "ft_to_lang")
        if type(existing) == "function" then
          return existing
        end
        return _G._nvim_ft_to_lang_shim
      end

      local v = rawget(lang, k)
      if v ~= nil then
        return v
      end

      return lang[k]
    end,
    __newindex = function(_, k, v)
      rawset(lang, k, v)
    end,
    __pairs = function()
      return pairs(lang)
    end,
  }

  return setmetatable(proxy, mt)
end

local function _apply_ft_to_lang_shim()
  if vim.treesitter == nil then
    local ok, ts_mod = pcall(require, "vim.treesitter")
    if ok and vim.treesitter == nil then
      vim.treesitter = ts_mod
    end
  end

  local ts = vim.treesitter
  if type(ts) ~= "table" then
    return
  end

  local shim = _G._nvim_ft_to_lang_shim
  if type(shim) ~= "function" then
    return
  end

  local lang = ts.language
  local lang_mt = type(lang) == "table" and getmetatable(lang) or nil
  if type(lang_mt) == "table" and lang_mt.__nvim_ft_to_lang_proxy == true then
    lang = lang_mt.__nvim_lang_actual
  end

  if lang == nil then
    local ok, lang_mod = pcall(require, "vim.treesitter.language")
    if ok and ts.language == nil then
      ts.language = lang_mod
      lang = lang_mod
    end
  end

  if type(lang) ~= "table" then
    return
  end

  rawset(lang, "ft_to_lang", shim)

  local cur_lang = ts.language
  local cur_mt = type(cur_lang) == "table" and getmetatable(cur_lang) or nil
  if not (type(cur_mt) == "table" and cur_mt.__nvim_ft_to_lang_proxy == true) then
    rawset(ts, "language", _make_ts_language_proxy(lang))
  end

  local ts_mt = getmetatable(ts)
  if type(ts_mt) ~= "table" then
    ts_mt = {}
  end

  if ts_mt.__nvim_ts_language_proxy ~= true then
    local orig_newindex = ts_mt.__newindex
    ts_mt.__newindex = function(t, k, v)
      if k == "language" and type(v) == "table" then
        local v_mt = getmetatable(v)
        if not (type(v_mt) == "table" and v_mt.__nvim_ft_to_lang_proxy == true) then
          rawset(v, "ft_to_lang", shim)
          v = _make_ts_language_proxy(v)
        end
      end

      if type(orig_newindex) == "function" then
        return orig_newindex(t, k, v)
      end

      if type(orig_newindex) == "table" then
        orig_newindex[k] = v
        return
      end

      rawset(t, k, v)
    end
    ts_mt.__nvim_ts_language_proxy = true
    setmetatable(ts, ts_mt)
  end
end
>>>>>>> REPLACE
````
</AIP_FILE_CHANGE>


<AIP_FILE_CHANGE file_path="lua/configs/restore-point-2026-02-15-133449.lua">
````lua
-- RESTORE POINT: 2026-02-15T13:34:49-07:00 (Sunday)
-- This file documents the state before making the Treesitter ft_to_lang shim persistent.
--
-- To restore, revert the following files to their state before this date:
--   - init.lua
--
-- Changes made:
--   1. init.lua: Installed a vim.treesitter.language proxy so ft_to_lang is always available,
--      and wrapped future vim.treesitter.language assignments to prevent regression.
--
-- Git command to restore (if committed):
--   git checkout HEAD~1 -- init.lua

return {
  restore_date = "2026-02-15T13:34:49-07:00",
  description = "Before making Treesitter ft_to_lang shim persistent via proxy",
}
````
</AIP_FILE_CHANGE>

