-- External colorscheme plugins
-- All loaded eagerly (lazy=false, priority=1000) so they're available
-- via :Telescope colorscheme and <leader>th at all times.
return {
  -- ── Existing (fixed) ────────────────────────────────────────────
  {
    "sainnhe/edge",
    lazy = false,
    priority = 1000,
  },
  {
    "sho-87/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
  },
  {
    "tiagovla/tokyodark.nvim",
    lazy = false,
    priority = 1000,
    config = function(_, opts)
      require("tokyodark").setup(opts or {})
    end,
  },

  -- ── New additions ───────────────────────────────────────────────
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
  },
  {
  "christoomey/vim-tmux-navigator",
  },
}
