return {
  'mrjones2014/legendary.nvim',
  dependencies = {
    'hinell/duplicate.nvim',
  },
  priority = 900,
  lazy = false,
  config = function()
    local legendary = require 'legendary'
    legendary.keymaps {
      -- duplicate
      {
        description = 'Line: duplicate up',
        mode = { 'n' },
        '<leader>lu',
        '<CMD>LineDuplicate -1<CR>',
      },
      {
        description = 'Line: duplicate down',
        mode = { 'n' },
        '<leader>ld',
        '<CMD>LineDuplicate +1<CR>',
      },
      {
        description = 'Selection: duplicate up',
        mode = { 'v' },
        '<leader>ls',
        '<CMD>VisualDuplicate -1<CR>',
      },
      {
        description = 'Selection: duplicate down',
        mode = { 'v' },
        '<leader>lt',
        '<CMD>VisualDuplicate +1<CR>',
      },
    }
  end,
}
