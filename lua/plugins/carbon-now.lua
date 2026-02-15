-- Code snippet screenshot
-- Ported from nvim-jan-2026-working.bak
return {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  opts = {
    base_url = "https://carbon.now.sh/",
    options = {
      bg = "gray",
      drop_shadow_blur = "68px",
      drop_shadow = false,
      drop_shadow_offset_y = "20px",
      font_family = "Hack",
      font_size = "18px",
      line_height = "133%",
      line_numbers = true,
      theme = "monokai",
      titlebar = "Code-snippet",
      watermark = false,
      width = "680",
      window_theme = "sharp",
      padding_horizontal = "0px",
      padding_vertical = "0px",
    },
  },
}
