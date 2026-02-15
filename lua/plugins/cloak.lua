return {
  "laytan/cloak.nvim",
  event = "VeryLazy",
  config = function()
    require("cloak").setup({
      enabled = true,
      cloak_character = "*",
      highlight_group = "Comment",
      patterns = {
        {
          file_pattern = {
            ".env*",
            ".env",
            "env",
            "env.rs",
            "wrangler.toml",
            ".dev.vars",
          },
          cloak_pattern = "=.*"
        },
      },
    })
  end
}
