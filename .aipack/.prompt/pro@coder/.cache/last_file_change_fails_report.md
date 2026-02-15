❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# init.lua

Failed searches:

````
  local lang = ts.language
  if type(lang) ~= "table" then
    return
  end

  if type(_G._nvim_ft_to_lang_shim) == "function" then
    rawset(lang, "ft_to_lang", _G._nvim_ft_to_lang_shim)
  end
end
````

❗ Here are the file change search misses.
See full AI response at:
.aipack/.prompt/pro@coder/.cache/last_ai_responses_for_raw.md

Below are the search misses by file:

# init.lua

Failed searches:

````
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
````

