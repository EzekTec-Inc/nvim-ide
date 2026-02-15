-- require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

local opt = vim.opt
local o = vim.o
local g = vim.g

-- FIX 2026-02-13T23:47:40: ft_to_lang shim is defined in init.lua before lazy.nvim loads

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = "   "

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- FIX 2026-02-13T23:18:09: fillchars is now set in init.lua nvim-ufo init function
-- The E1511 error occurs when foldcolumn > 0 and fillchars foldopen/foldclose are invalid
-- By setting fillchars in nvim-ufo init BEFORE any fold operations, we avoid the error
-- Do NOT set fillchars here to prevent conflicts
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = true

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- g.mapleader = " "

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
