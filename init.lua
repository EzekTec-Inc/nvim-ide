if vim.loader then
  vim.loader.enable()
end

collectgarbage("setpause", 100)
collectgarbage("setstepmul", 400)

vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

require("shims")

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    desc = "Custom Terminal Setup",
    config = function()
      require("options")
      -- require("nvchad.term").new { pos = "sp", size = 0.3 }
      -- require("nvchad.term").new { pos = "vsp", cmd = "neofetch"}
    end,
  },

  { import = "plugins" },
  "ryanoasis/vim-devicons",
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvchad.autocmds")

vim.schedule(function()
  require("mappings")
  if type(_G._nvchad_clipboard_post_mappings_fix) == "function" then
    pcall(_G._nvchad_clipboard_post_mappings_fix)
  end
end)


local function cade_export_theme()
  local function int_to_hex(color)
    return color and string.format("#%06x", color) or nil
  end

  local function get_hl_prop(name, prop)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if hl and hl.link then hl = vim.api.nvim_get_hl(0, { name = hl.link, link = false }) end
    return hl and hl[prop] and int_to_hex(hl[prop]) or nil
  end

  local function c_fg(...)
    for _, group in ipairs({ ... }) do
      local color = get_hl_prop(group, "fg")
      if color then return color end
    end
  end

  local function c_bg(...)
    for _, group in ipairs({ ... }) do
      local color = get_hl_prop(group, "bg")
      if color then return color end
    end
  end

  local text_color = c_fg("Normal") or "#FFFFFF"
  local normal_bg = c_bg("Normal") or ""
  local accent = c_fg("Statement", "Function", "Keyword") or "#000000"
  local dim = c_fg("NonText", "Conceal") or "#888888"

  local colors = {
    accent = accent,
    border = c_fg("FloatBorder", "WinSeparator", "LineNr"),
    borderAccent = c_fg("TelescopeBorder") or accent,
    borderMuted = c_fg("Comment", "NonText"),
    success = c_fg("DiagnosticOk", "String"),
    error = c_fg("DiagnosticError", "ErrorMsg"),
    warning = c_fg("DiagnosticWarn", "WarningMsg"),
    muted = c_fg("Comment", "LineNr"),
    dim = dim,
    text = text_color,
    thinkingText = c_fg("Comment") or dim,
    selectedBg = c_bg("Visual", "CursorLine"),
    userMessageBg = c_bg("NormalFloat", "CursorLine"),
    userMessageText = c_fg("NormalFloat", "Normal") or text_color,
    customMessageBg = c_bg("NormalFloat", "Normal") or normal_bg,
    customMessageText = c_fg("NormalFloat", "Normal") or text_color,
    toolPendingBg = c_bg("CursorLine", "ColorColumn"),
    toolSuccessBg = c_bg("DiffAdd", "Normal") or normal_bg,
    toolErrorBg = c_bg("DiffDelete", "ErrorMsg"),
    toolTitle = c_fg("Title", "Function"),
    toolOutput = text_color,
  }

  for k, v in pairs(colors) do if not v then colors[k] = "" end end

  local theme = { name = "nvim-exported", author = "cade.nvim", colors = colors }
  local theme_dir = os.getenv("HOME") .. "/.cade/themes"
  vim.fn.mkdir(theme_dir, "p")
  local file = io.open(theme_dir .. "/nvim-exported.json", "w")
  if file then
    file:write(vim.fn.json_encode(theme))
    file:close()
  end
end

-- Export on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = cade_export_theme,
})
-- Run once on startup
cade_export_theme()
