return {
  "Shatur/neovim-session-manager",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = function()
    local Path = require('plenary.path')
    local config = require('session_manager.config')
    require('session_manager').setup({
      sessions_dir = Path:new(vim.fn.stdpath('config'), 'sessions'),
      autosave_last_session = true,
      autosave_ignore_not_normal = true,
      autosave_ignore_dirs = {},
      autosave_ignore_filetypes = {
        'gitcommit',
        'gitrebase',
      },
      autosave_ignore_buftypes = {},
      autosave_only_in_session = true,
      max_path_length = 80,
    })
  end,
}
