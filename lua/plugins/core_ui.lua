-- ==============================================================================
-- Module:      plugins/core_ui
-- Description: Core User Interface plugins.
--              Manages themes (base46, nvchad/ui), Telescope, WhichKey, etc.
-- ==============================================================================
return {
  {
    "NvChad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "NvChad/ui",
    lazy = false,
    build = function()
      dofile(vim.fn.stdpath "data" .. "/lazy/ui/lua/nvchad_feedback.lua")()
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
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
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
    config = function(_, opts)
      if type(_G._apply_ft_to_lang_shim) == "function" then
        pcall(_G._apply_ft_to_lang_shim)
      end

      if type(vim.g.base46_cache) == "string" and vim.g.base46_cache ~= "" then
        pcall(dofile, vim.g.base46_cache .. "telescope")
      end

      local telescope = require "telescope"
      telescope.setup(opts)

      local extensions_list = opts.extensions_list or {}
      for _, ext in ipairs(extensions_list) do
        pcall(telescope.load_extension, ext)
      end
      pcall(telescope.load_extension, "themes")

      local ok_builtin, builtin = pcall(require, "telescope.builtin")
      if ok_builtin then
        builtin.themes = function(theme_opts)
          theme_opts = theme_opts or {}

          if type(_G._apply_ft_to_lang_shim) == "function" then
            pcall(_G._apply_ft_to_lang_shim)
          end

          if type(_G._patch_telescope_previewer_utils) == "function" then
            pcall(_G._patch_telescope_previewer_utils)
          end

          local themes_ext = telescope.extensions and telescope.extensions.themes
          if themes_ext then
            local picker = themes_ext
            if type(themes_ext) == "table" then
              picker = themes_ext.themes
            end

            if type(picker) == "function" then
              local ok_picker, err = pcall(picker, theme_opts)
              if ok_picker then
                return
              else
                if err and type(err) == "string" then
                  vim.notify("NvChad theme picker error: " .. err, vim.log.levels.WARN)
                end
              end
            end
          end

          if type(builtin.colorscheme) == "function" then
            local ok_cs, err = pcall(builtin.colorscheme, theme_opts)
            if not ok_cs and err then
              vim.notify("Colorscheme fallback error: " .. tostring(err), vim.log.levels.ERROR)
            end
            return
          end

          vim.notify("No theme picker available", vim.log.levels.ERROR)
        end
      end

      if type(_G._apply_telescope_nvchad_themes_picker) == "function" then
        pcall(_G._apply_telescope_nvchad_themes_picker)
      end
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "User FilePost",
    opts = {
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
        RGB = true,
        RRGGBB = true,
        names = true,
        RRGGBBAA = false,
        AARRGGBB = false,
        rgb_fn = false,
        hsl_fn = false,
        css = false,
        css_fn = false,
        mode = "background",
        tailwind = false,
        sass = { enable = false, parsers = { "css" } },
        virtualtext = "■",
        always_update = false,
      },
      buftypes = {},
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "html", "svelte", "astro", "vue", "typescriptreact", "javascriptreact" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
}
