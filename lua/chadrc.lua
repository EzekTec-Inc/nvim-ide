-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
--
-- require("nvchad.options")
--
-- ---@type ChadrcConfig
-- local M = {}
--
-- -- M.ui = {theme = 'catppuccin'} -- This was the default I selected initially
-- M.ui = {
-- 	theme = "vscode_dark",
--
-- 	-- hl_override = {
-- 	-- 	Comment = { italic = true },
-- 	-- 	["@comment"] = { italic = true },
-- 	-- },
-- }
--
-- M.plugins = 'custom.plugins'
--
-- return M

-- NVChad themes picker entrypoint, avoids the Telescope builtin `themes` (layout themes) picker.
do
  if type(_G._nvchad_open_themes_picker) ~= "function" then
    _G._nvchad_open_themes_picker = function(opts)
      opts = opts or {}

      if type(_G._apply_ft_to_lang_shim) == "function" then
        pcall(_G._apply_ft_to_lang_shim)
      end

      local base46_cache = vim.g.base46_cache
      if type(base46_cache) == "string" and base46_cache ~= "" then
        local telescope_hl_path = base46_cache .. "telescope"
        local stat_ok = pcall(vim.loop.fs_stat, telescope_hl_path)
        if stat_ok then
          pcall(dofile, telescope_hl_path)
        end
      end

      local ok_telescope, telescope = pcall(require, "telescope")
      if not ok_telescope or type(telescope) ~= "table" then
        local ok_lazy, lazy = pcall(require, "lazy")
        if ok_lazy and type(lazy) == "table" and type(lazy.load) == "function" then
          pcall(lazy.load, { plugins = { "telescope.nvim" } })
        end

        ok_telescope, telescope = pcall(require, "telescope")
        if not ok_telescope or type(telescope) ~= "table" then
          vim.notify("Telescope not available, falling back to colorscheme picker", vim.log.levels.WARN)
          pcall(vim.cmd, "Telescope colorscheme")
          return
        end
      end

      local themes_ext = telescope.extensions and telescope.extensions.themes
      if not (themes_ext and (type(themes_ext) == "function" or (type(themes_ext) == "table" and type(themes_ext.themes) == "function"))) then
        local ok_ext, ext_module = pcall(require, "telescope._extensions.themes")
        if ok_ext and type(ext_module) == "table" then
          local load_ok = pcall(telescope.load_extension, "themes")
          if load_ok then
            themes_ext = telescope.extensions and telescope.extensions.themes
          end
        end
      end

      if themes_ext then
        local picker = themes_ext
        if type(themes_ext) == "table" then
          picker = themes_ext.themes
        end

        if type(picker) == "function" then
          local ok_picker, err = pcall(picker, opts)
          if ok_picker then
            return
          else
            if err and type(err) == "string" then
              vim.notify("Theme picker error: " .. err, vim.log.levels.ERROR)
            end
          end
        end
      end

      local ok_builtin, builtin = pcall(require, "telescope.builtin")
      if ok_builtin and type(builtin) == "table" and type(builtin.colorscheme) == "function" then
        local ok_cs, err = pcall(builtin.colorscheme, opts)
        if not ok_cs and err then
          vim.notify("Colorscheme picker error: " .. tostring(err), vim.log.levels.ERROR)
        end
      else
        vim.notify("No theme picker available", vim.log.levels.ERROR)
      end
    end
  end
end

local options = {

  base46 = {
    theme = "vscode_dark", -- default theme
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = false,
    theme_toggle = { "vscode_dark", "catppuccin_light" },
  },

  ui = {
    theme = "vscode_dark",
    theme_toggle = { "vscode_dark", "catppuccin_light" },

    cmp = {
      icons = true,
      lspkind_text = true,
      style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    },

    telescope = { style = "borderless" }, -- borderless / bordered

    statusline = {
      theme = "default", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "default",
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = true,
      order = { "treeOffset", "buffers", "tabs", "btns" },
      modules = nil,
    },

    nvdash = {
      load_on_startup = true,

      header = {
        "           ▄ ▄                   ",
        "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
        "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
        "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
        "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
        "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
        "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
        "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
        "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
      },

      buttons = {
        { "  Find File", "Spc f f", "Telescope find_files" },
        { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
        { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
        { "  Bookmarks", "Spc m a", "Telescope marks" },
        { "  Themes", "Spc t h", "lua _G._nvchad_open_themes_picker()" },
        { "  Mappings", "Spc c h", "NvCheatsheet" },
      },
    },
  },

  term = {
    winopts = { number = true, relativenumber = true },
    sizes = { sp = 0.3, vsp = 0.2, ["bo sp"] = 0.3, ["bo vsp"] = 0.2 },
    float = {
      relative = "editor",
      row = 0.3,
      col = 0.25,
      width = 0.5,
      height = 0.4,
      border = "single",
    },
  },

  lsp = { signature = true },

  cheatsheet = {
    theme = "grid", -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  mason = { cmd = true, pkgs = {} },
}

-- return vim.tbl_deep_extend("force", options, require "chadrc")
return options
