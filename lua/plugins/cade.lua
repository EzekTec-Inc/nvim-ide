-- CADE-nvim: inline AI code completions via the CADE server
return {
	{
		name = "cade",
		dir = "/home/engrubanese/Downloads/02 Rust-project/CADE/editors/neovim",
		lazy = false,
		config = function()
			require("cade").setup({})
		end,
	},
}
