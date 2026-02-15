-- Restore Point: 2026-02-13T23:17:00-07:00
-- Description: Fix for E1511 "Wrong number of characters for field foldopen" error
--
-- Problem:
--   init.lua nvim-ufo config was using vim.o for fold settings which can
--   trigger fillchars validation errors when combined with other settings
--
-- Error message:
--   E1511: Wrong number of characters for field "foldopen"
--   at init.lua:301 in nvim-ufo config
--
-- Solution:
--   Changed vim.o.foldenable, vim.o.foldlevel, vim.o.foldlevelstart to use
--   vim.opt instead of vim.o to avoid triggering fillchars field validation
--
-- Files modified:
--   - init.lua (nvim-ufo config section)
--
-- To restore previous state:
--   In init.lua nvim-ufo config, change:
--     vim.opt.foldenable = true
--     vim.opt.foldlevel = 99
--     vim.opt.foldlevelstart = 99
--   Back to:
--     vim.o.foldenable = true
--     vim.o.foldlevel = 99
--     vim.o.foldlevelstart = 99

return {
  created = "2026-02-13T23:17:00-07:00",
  description = "Fix E1511 Wrong number of characters for field foldopen error",
  files_modified = {
    "init.lua",
  },
}
