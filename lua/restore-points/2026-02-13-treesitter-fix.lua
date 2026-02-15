-- Restore Point: 2026-02-13T22:07:35-07:00
-- Description: Fix for nvim-treesitter.configs module not found error
--
-- Problem:
--   lua/plugins/treesitter_extended.lua was attempting to require
--   'nvim-treesitter.configs' which no longer exists in nvim-treesitter 1.0+
--
-- Error message:
--   Failed to run `config` for nvim-treesitter-textobjects
--   module 'nvim-treesitter.configs' not found
--
-- Solution:
--   Changed lua/plugins/treesitter_extended.lua to return an empty table
--   All treesitter configuration is handled in lua/plugins/treesitter.lua
--
-- Files modified:
--   - lua/plugins/treesitter_extended.lua
--
-- To restore previous (broken) state:
--   This would restore the error; not recommended.
--   The previous file attempted to call require("nvim-treesitter.configs").setup()
--   which is incompatible with nvim-treesitter 1.0+

return {
  created = "2026-02-13T22:07:35-07:00",
  description = "Fix nvim-treesitter.configs module not found error",
  files_modified = {
    "lua/plugins/treesitter_extended.lua",
  },
}
