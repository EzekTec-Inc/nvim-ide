return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "quarto", "Avante" },
		opts = {
			file_types = { "markdown", "quarto", "Avante" },
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			checkbox = {
				enabled = true,
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)
			-- Optional: integrate with your existing colorscheme if needed
		end,
	},
}
