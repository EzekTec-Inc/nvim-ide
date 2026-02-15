-- No example configuration was found for this plugin.
--
-- For detailed information on configuring this plugin, please refer to its
-- official documentation:
--
--   https://github.com/mosheavni/yaml-companion.nvim
--
-- If you wish to use this plugin, you can optionally modify and then uncomment
-- the configuration below.

return {
  "mosheavni/yaml-companion.nvim",
  ft = { "yaml", "yml" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "b0o/schemastore.nvim",
  },
  config = function()
    require("telescope").load_extension("yaml_schema")
    local cfg = require("yaml-companion").setup({
      builtin_matchers = {
        kubernetes = { enabled = true },
        cloud_init = { enabled = true },
      },
      schemas = {},
      lspconfig = {
        settings = {
          yaml = {
            validate = true,
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      },
    })
    require("lspconfig")["yamlls"].setup(cfg)
  end,
}
