-- FIX 2026-02-13T23:54:07: ft_to_lang shim is now handled via metatable proxy in init.lua
-- The proxy ensures ft_to_lang is always available and cannot be overwritten to nil
-- This safety check is kept as a fallback but should not be needed
if
  vim.treesitter
  and type(vim.treesitter.language) == "table"
  and rawget(vim.treesitter.language, "ft_to_lang") == nil
  and _G._nvim_ft_to_lang_shim
then
  rawset(vim.treesitter.language, "ft_to_lang", _G._nvim_ft_to_lang_shim)
end

local base46_cache = vim.g.base46_cache
if type(base46_cache) == "string" and base46_cache ~= "" then
  pcall(dofile, base46_cache .. "telescope")
end

local options = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
  },

  extensions_list = { "themes", "terms" },
  extensions = {},
}

return options
