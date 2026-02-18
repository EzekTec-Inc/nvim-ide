vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

do
  if vim.g.clipboard == nil then
    local function exe(cmd)
      return vim.fn.executable(cmd) == 1
    end

    local name, copy, paste = nil, nil, nil

    if vim.fn.has("mac") == 1 and exe("pbcopy") and exe("pbpaste") then
      name = "pbcopy/pbpaste"
      copy = { "pbcopy" }
      paste = { "pbpaste" }
    elseif (vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1) and exe("win32yank.exe") then
      name = "win32yank"
      copy = { "win32yank.exe", "-i", "--crlf" }
      paste = { "win32yank.exe", "-o", "--lf" }
    elseif exe("wl-copy") and exe("wl-paste") then
      name = "wl-clipboard"
      copy = { "wl-copy", "--type", "text/plain" }
      paste = { "wl-paste", "--no-newline" }
    elseif exe("xclip") then
      name = "xclip"
      copy = { "xclip", "-selection", "clipboard" }
      paste = { "xclip", "-selection", "clipboard", "-o" }
    elseif exe("xsel") then
      name = "xsel"
      copy = { "xsel", "--clipboard", "--input" }
      paste = { "xsel", "--clipboard", "--output" }
    end

    if copy and paste then
      vim.g.clipboard = {
        name = "user-clipboard (" .. name .. ")",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = paste, ["*"] = paste },
        cache_enabled = 0,
      }
    end
  end
end

do
  local function ensure_clipboard_option()
    local ok = pcall(function()
      local clip = vim.opt.clipboard:get()
      if type(clip) == "table" and not vim.tbl_contains(clip, "unnamedplus") then
        vim.opt.clipboard:append("unnamedplus")
      end
    end)
    if not ok then
      vim.o.clipboard = "unnamedplus"
    end
  end

  local function del_if_rhs(mode, lhs, rhs)
    local ok_get, maps = pcall(vim.keymap.get, mode, lhs)
    if not ok_get or type(maps) ~= "table" then
      return
    end

    for _, m in ipairs(maps) do
      if type(m) == "table" and m.lhs == lhs and m.rhs == rhs and m.buffer == nil then
        pcall(vim.keymap.del, mode, lhs)
        return
      end
    end
  end

  _G._nvchad_clipboard_post_mappings_fix = function()
    ensure_clipboard_option()

    del_if_rhs("n", "y", '"0y')
    del_if_rhs("v", "y", '"0y')
    del_if_rhs("x", "y", '"0y')

    del_if_rhs("n", "Y", '"0y$')

    del_if_rhs("n", "yy", '"0yy')
    del_if_rhs("v", "yy", '"0yy')
    del_if_rhs("x", "yy", '"0yy')

    del_if_rhs("n", "p", '"0p')
    del_if_rhs("v", "p", '"0p')
    del_if_rhs("x", "p", '"0p')

    del_if_rhs("n", "P", '"0P')
    del_if_rhs("v", "P", '"0P')
    del_if_rhs("x", "P", '"0P')
  end

  ensure_clipboard_option()
end

do
  local group = vim.api.nvim_create_augroup("UserCoreLspKeymaps", { clear = true })

  local function apply(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end

    local function opts(desc)
      return { buffer = bufnr, desc = "LSP " .. desc, noremap = true, silent = true }
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts "Hover")
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts "Show signature help")
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      local bufnr = args.buf
      vim.schedule(function()
        apply(bufnr)
      end)
    end,
  })
end

-- FIX 2026-02-13T23:58:08: Robust ft_to_lang shim using metatable proxy
-- FIX 2026-02-15T13:55:51: Enhanced shim to also patch telescope.previewers.utils directly
-- The ft_to_lang function was removed in Neovim 0.10+
-- Telescope previewers still reference it, causing "attempt to call field 'ft_to_lang' (a nil value)"
-- Previous direct assignment approaches failed because plugins can overwrite the table
-- Solution: Use a metatable proxy that intercepts all access to vim.treesitter.language
-- AND patch telescope.previewers.utils.ts_highlighter to use our shim

-- Create the shim function that wraps get_lang (the Neovim 0.10+ replacement)
local function _nvim_ft_to_lang_shim(ft)
  if type(ft) ~= "string" or ft == "" then
    return ""
  end

  -- Try get_lang first (Neovim 0.10+)
  local lang_tbl = vim.treesitter and vim.treesitter.language
  local get_lang = lang_tbl and rawget(lang_tbl, "get_lang")
  if type(get_lang) == "function" then
    local ok, lang = pcall(get_lang, ft)
    if ok and type(lang) == "string" and lang ~= "" then
      return lang
    end
  end

  -- Fallback: return filetype as-is (many filetypes map directly to their language name)
  return ft
end

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

    local mt = getmetatable(lang) or {}
    if mt.__nvchad_ft_to_lang_shim_applied ~= true then
      local prev_index = mt.__index
      mt.__index = function(t, k)
        if k == "ft_to_lang" then
          return _G._nvim_ft_to_lang_shim
        end

        if type(prev_index) == "function" then
          return prev_index(t, k)
        elseif type(prev_index) == "table" then
          return prev_index[k]
        end
      end
      mt.__nvchad_ft_to_lang_shim_applied = true
      pcall(setmetatable, lang, mt)
    end
  end
end

_G._apply_ft_to_lang_shim = _apply_ft_to_lang_shim

-- FIX 2026-02-15T13:55:51: Patch telescope.previewers.utils to use our shim
local function _patch_telescope_previewer_utils()
  local ok_utils, utils = pcall(require, "telescope.previewers.utils")
  if not ok_utils or type(utils) ~= "table" then
    return
  end

  -- Store original ts_highlighter if not already patched
  if utils._original_ts_highlighter == nil and type(utils.ts_highlighter) == "function" then
    utils._original_ts_highlighter = utils.ts_highlighter
  end

  -- Replace ts_highlighter with a version that ensures ft_to_lang exists
  utils.ts_highlighter = function(bufnr, ft)
    -- Ensure the shim is applied before calling the original
    if type(_G._apply_ft_to_lang_shim) == "function" then
      _G._apply_ft_to_lang_shim()
    end

    -- Double-check ft_to_lang exists
    if vim.treesitter and vim.treesitter.language then
      if type(vim.treesitter.language.ft_to_lang) ~= "function" then
        rawset(vim.treesitter.language, "ft_to_lang", _G._nvim_ft_to_lang_shim)
      end
    end

    -- Call original if it exists
    if type(utils._original_ts_highlighter) == "function" then
      return utils._original_ts_highlighter(bufnr, ft)
    end

    -- Fallback implementation if original doesn't exist
    if not ft or ft == "" then
      return false
    end

    local lang = _G._nvim_ft_to_lang_shim(ft)
    if not lang or lang == "" then
      return false
    end

    local ok_highlight = pcall(vim.treesitter.start, bufnr, lang)
    return ok_highlight
  end
end

_G._patch_telescope_previewer_utils = _patch_telescope_previewer_utils

-- FIX 2026-02-15T12:56:41: Ensure :Telescope themes routes to NvChad theme picker.

local function _apply_telescope_nvchad_themes_picker()
  local ok_builtin, builtin = pcall(require, "telescope.builtin")
  if not ok_builtin then
    return
  end

  if type(_G._nvchad_open_themes_picker) ~= "function" then
    pcall(require, "chadrc")
  end

  if type(_G._nvchad_open_themes_picker) == "function" then
    builtin.themes = function(opts)
      opts = opts or {}
      if type(_G._apply_ft_to_lang_shim) == "function" then
        pcall(_G._apply_ft_to_lang_shim)
      end
      if type(_G._patch_telescope_previewer_utils) == "function" then
        pcall(_G._patch_telescope_previewer_utils)
      end
      return _G._nvchad_open_themes_picker(opts)
    end
    return
  end

  local ok_telescope, telescope = pcall(require, "telescope")
  if ok_telescope then
    local themes_ext = telescope.extensions and telescope.extensions.themes
    local picker = nil

    if themes_ext then
      if type(themes_ext) == "function" then
        picker = themes_ext
      elseif type(themes_ext) == "table" and type(themes_ext.themes) == "function" then
        picker = themes_ext.themes
      end
    end

    if type(picker) ~= "function" then
      local ok_ext = pcall(require, "telescope._extensions.themes")
      if ok_ext then
        pcall(telescope.load_extension, "themes")
      end
      themes_ext = telescope.extensions and telescope.extensions.themes
      if themes_ext then
        if type(themes_ext) == "function" then
          picker = themes_ext
        elseif type(themes_ext) == "table" and type(themes_ext.themes) == "function" then
          picker = themes_ext.themes
        end
      end
    end

    if type(picker) == "function" then
      builtin.themes = function(opts)
        opts = opts or {}
        local base46_cache = vim.g.base46_cache
        if type(base46_cache) == "string" and base46_cache ~= "" then
          pcall(dofile, base46_cache .. "telescope")
        end
        if type(_G._apply_ft_to_lang_shim) == "function" then
          pcall(_G._apply_ft_to_lang_shim)
        end
        if type(_G._patch_telescope_previewer_utils) == "function" then
          pcall(_G._patch_telescope_previewer_utils)
        end
        return picker(opts)
      end
      return
    end
  end

  builtin.themes = function(opts)
    opts = opts or {}
    local base46_cache = vim.g.base46_cache
    if type(base46_cache) == "string" and base46_cache ~= "" then
      pcall(dofile, base46_cache .. "telescope")
    end

    if type(_G._apply_ft_to_lang_shim) == "function" then
      pcall(_G._apply_ft_to_lang_shim)
    end

    if type(_G._patch_telescope_previewer_utils) == "function" then
      pcall(_G._patch_telescope_previewer_utils)
    end

    if type(_G._nvchad_open_themes_picker) ~= "function" then
      pcall(require, "chadrc")
    end

    if type(_G._nvchad_open_themes_picker) == "function" then
      return _G._nvchad_open_themes_picker(opts)
    end

    if type(builtin.colorscheme) == "function" then
      return builtin.colorscheme(opts)
    end
  end
end

_G._apply_telescope_nvchad_themes_picker = _apply_telescope_nvchad_themes_picker

local function _apply_nvchad_themes_and_ft_to_lang_shims()
  _apply_ft_to_lang_shim()
  _patch_telescope_previewer_utils()
  _apply_telescope_nvchad_themes_picker()
end

_apply_nvchad_themes_and_ft_to_lang_shims()
vim.defer_fn(_apply_nvchad_themes_and_ft_to_lang_shims, 0)

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyDone",
  once = true,
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

-- FIX 2026-02-15T13:09:31-07:00: Re-apply shims on LazyLoad to cover lazy-loaded Telescope.

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = _apply_nvchad_themes_and_ft_to_lang_shims,
})

-- FIX 2026-02-17T13:18:55-07:00: Lock core navigation keymaps in LSP-attached buffers.
do
  local augroup = vim.api.nvim_create_augroup("NvLspKeymapsLock", { clear = true })

  local function lsp_hover()
    if vim.fn.exists(":RustLsp") == 2 then
      local ok = pcall(vim.cmd.RustLsp, { "hover", "actions" })
      if ok then
        return
      end
    end

    pcall(vim.lsp.buf.hover)
  end

  local function lock_keymaps(bufnr)
    if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
      return
    end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, silent = true })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, silent = true })
    vim.keymap.set("n", "K", lsp_hover, { buffer = bufnr, silent = true })

    vim.keymap.set("n", "gk", "gk", { buffer = bufnr, silent = true, noremap = true })
    vim.keymap.set({ "n", "v" }, "gq", "gq", { buffer = bufnr, silent = true, noremap = true })
  end

  local function get_clients(bufnr)
    local fn = vim.lsp.get_clients or vim.lsp.get_active_clients
    if type(fn) ~= "function" then
      return {}
    end
    local ok, clients = pcall(fn, { bufnr = bufnr })
    if ok and type(clients) == "table" then
      return clients
    end
    return {}
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(args)
      vim.schedule(function()
        lock_keymaps(args.buf)
      end)
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function(args)
      local bufnr = args.buf
      if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
        return
      end

      local clients = get_clients(bufnr)
      if #clients == 0 then
        return
      end

      vim.schedule(function()
        lock_keymaps(bufnr)
      end)
    end,
  })
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    desc = "Custom Terminal Setup",
    config = function()
      require "options"
      -- require("nvchad.term").new { pos = "sp", size = 0.3 }
      -- require("nvchad.term").new { pos = "vsp", cmd = "neofetch"}
    end,
  },

  { import = "plugins" },
  "ryanoasis/vim-devicons",

  -- In .lua
  {
    "kyazdani42/nvim-web-devicons",
    opt = true,
    config = function()
      require("nvim-web-devicons").setup {
        default = true,
      }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = {},
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  -- formatting!
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rust_analyzer" },
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "nvchad.configs.mason"
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lsp").defaults()
      require("configs.lsp").setup_lua_ls()
    end,
  },

  {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup completions for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      if type(_G._apply_ft_to_lang_shim) == "function" then
        pcall(_G._apply_ft_to_lang_shim)
      end

      if type(_G._patch_telescope_previewer_utils) == "function" then
        pcall(_G._patch_telescope_previewer_utils)
      end

      if type(vim.g.base46_cache) == "string" and vim.g.base46_cache ~= "" then
        pcall(dofile, vim.g.base46_cache .. "telescope")
      end

      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      local extensions_list = opts.extensions_list or {}
      for _, ext in ipairs(extensions_list) do
        pcall(telescope.load_extension, ext)
      end
      pcall(telescope.load_extension, "themes")

      if type(_G._apply_telescope_nvchad_themes_picker) == "function" then
        pcall(_G._apply_telescope_nvchad_themes_picker)
      end
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
      -- user_default_options = { names = false },
      css = true,
      filetypes = {
        "css",
        "javascript",
        "rust",
        html = { mode = "foreground" },
        "*",
        "!lazy",
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■",
        always_update = false,
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
    config = function(_, opts)
      -- nvim-treesitter 1.0+ removed the configs module
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if ok and ts_configs and ts_configs.setup then
        ts_configs.setup(opts)
      else
        local ts_ok, ts = pcall(require, "nvim-treesitter")
        if ts_ok and ts and ts.setup then
          ts.setup(opts)
        end
      end
    end,
  },

  {
    "Exafunction/codeium.vim",
    event = "BufEnter",
    config = function() end,
  },

  -- in 'custom/plugins.lua' file
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
  },


  -- code folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    init = function()
      -- FIX 2026-02-13T23:18:09: Set fold options BEFORE plugin loads
      -- E1511 error occurs when foldcolumn > 0 and fillchars foldopen/foldclose are invalid
      -- Setting foldcolumn to "0" disables the fold column entirely, avoiding fillchars validation
      -- nvim-ufo displays folds via virtual text, not the fold column
      vim.o.foldcolumn = "0"
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldmethod = "manual"
      -- Set fillchars without any fold-related fields to avoid E1511
      -- Only set eob (end of buffer) and fold fields which accept any character
      vim.opt.fillchars = { eob = " ", fold = " " }
    end,
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" ... %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      require("ufo").setup({
        fold_virt_text_handler = handler,
        preview = {
          win_config = {
            border = "rounded",
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      })
    end,
  },

  -- floating terminal
  {
    "numToStr/FTerm.nvim",
    lazy = false,
    config = function()
      require("FTerm").setup({
        border = "double",
        dimensions = {
          height = 0.9,
          width = 0.9,
        },
      })
    end,
  },

  -- toggleable horizontal terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false,
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = nil,
        direction = "horizontal",
        close_on_exit = true,
        shell = vim.o.shell,
      })
    end,
  },

}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line "'\""
    if
      line > 1
      and line <= vim.fn.line "$"
      and vim.bo.filetype ~= "commit"
      and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
    then
      vim.cmd 'normal! g`"'
    end
  end,
})

autocmd("VimEnter", {
  command = ":silent !bash @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
  command = ":silent !bash @ set-spacing padding=20 margin=10",
})

vim.schedule(function()
  require "mappings"
  if type(_G._nvchad_clipboard_post_mappings_fix) == "function" then
    pcall(_G._nvchad_clipboard_post_mappings_fix)
  end
end)
