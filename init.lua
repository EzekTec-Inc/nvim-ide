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
