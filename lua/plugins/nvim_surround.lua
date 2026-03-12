-- nvim-surround
-- Adds ys (you surround), cs (change surround), ds (delete surround)
-- Works with any text object, including the treesitter-textobjects above.
--
-- Quick reference:
--   ys<motion><char>  → surround motion with char   e.g. ysiw"  ysa(  ysif{
--   cs<old><new>       → change surrounding           e.g. cs"'   cs({
--   ds<char>           → delete surrounding           e.g. ds"    ds(
--   (visual) S<char>   → surround selection
--
-- Aliases (built-in):
--   b → )   B → }   r → ]   a → >
return {
  "kylechui/nvim-surround",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-surround").setup {
      -- keymaps mirror tpope/vim-surround defaults — no changes needed
      keymaps = {
        insert          = "<C-g>s",
        insert_line     = "<C-g>S",
        normal          = "ys",
        normal_cur      = "yss",
        normal_line     = "yS",
        normal_cur_line = "ySS",
        visual          = "S",
        visual_line     = "gS",
        delete          = "ds",
        change          = "cs",
        change_line     = "cS",
      },
    }
  end,
}
