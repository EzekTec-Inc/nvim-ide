-- Restore Point: 2026-02-13T23:54:07-07:00
-- Description: Fix for Telescope ft_to_lang nil error using metatable proxy
--
-- Problem:
--   Telescope previewers call vim.treesitter.language.ft_to_lang which was
--   removed in Neovim 0.10+. Previous shim attempts using direct assignment
--   and autocmds were not reliable as the function could be overwritten.
--
-- Error message:
--   attempt to call field 'ft_to_lang' (a nil value)
--   at telescope/previewers/utils.lua:135
--
-- Solution:
--   Use a metatable proxy on vim.treesitter.language that intercepts all
--   accesses to "ft_to_lang" and always returns the shim function. This
--   approach cannot be overwritten by other modules setting the field to nil.
--
-- Files modified:
--   - init.lua (ft_to_lang shim section)
--
-- To restore previous state:
--   In init.lua, replace the metatable proxy code with simple direct assignment:
--
--   local function _nvim_ft_to_lang_shim(ft)
--     if not ft or ft == "" then return ft or "" end
--     if vim.treesitter.language.get_lang then
--       local ok, lang = pcall(vim.treesitter.language.get_lang, ft)
--       if ok and lang then return lang end
--     end
--     return ft
--   end
--   _G._nvim_ft_to_lang_shim = _nvim_ft_to_lang_shim
--   vim.treesitter.language.ft_to_lang = _nvim_ft_to_lang_shim

return {
  created = "2026-02-13T23:54:07-07:00",
  description = "Fix Telescope ft_to_lang nil error using metatable proxy",
  files_modified = {
    "init.lua",
  },
}
