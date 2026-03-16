-- Neovim & NvChad Compatibility Shims

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
		return false
	end

	if type(_G._apply_ft_to_lang_shim) == "function" then
		pcall(_G._apply_ft_to_lang_shim)
	end

	if utils._nvchad_ts_highlighter_patched then
		return true
	end

	if type(utils.ts_highlighter) == "function" then
		utils._original_ts_highlighter = utils.ts_highlighter
	end

	utils.ts_highlighter = function(bufnr, ft)
		if type(_G._apply_ft_to_lang_shim) == "function" then
			pcall(_G._apply_ft_to_lang_shim)
		end

		if vim.treesitter and type(vim.treesitter.language) == "table" then
			if type(vim.treesitter.language.ft_to_lang) ~= "function" then
				if type(_G._nvim_ft_to_lang_shim) == "function" then
					rawset(vim.treesitter.language, "ft_to_lang", _G._nvim_ft_to_lang_shim)
				end
			end
		end

		if type(utils._original_ts_highlighter) == "function" then
			local ok, result = pcall(utils._original_ts_highlighter, bufnr, ft)
			if ok then
				return result
			end
		end

		if not ft or ft == "" then
			return false
		end

		if type(_G._nvim_ft_to_lang_shim) == "function" then
			local lang = _G._nvim_ft_to_lang_shim(ft)
			if lang and lang ~= "" then
				local ok_highlight = pcall(vim.treesitter.start, bufnr, lang)
				return ok_highlight
			end
		end

		return false
	end

	utils._nvchad_ts_highlighter_patched = true
	return true
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
-- Suppress lspsaga.nvim client.request/client.supports_method deprecation warnings.
-- lspsaga/symbol/head.lua registers its own LspAttach autocmd and calls these
-- regardless of symbol_in_winbar.enable setting. Will be removed in Nvim 0.13.
-- Intercept vim.deprecate to filter only these two names; all others pass through.
do
	local _orig_deprecate = vim.deprecate
	vim.deprecate = function(name, alternative, version, ...)
		if name == "client.request" or name == "client.supports_method" then
			return
		end
		return _orig_deprecate(name, alternative, version, ...)
	end
end

-- Compat shim: vim.lsp.buf_get_clients deprecated in 0.10, removed in 0.12
-- Used by action-hints.nvim (roobert/action-hints.nvim)
vim.lsp.buf_get_clients = function(bufnr)
	return vim.lsp.get_clients({ bufnr = bufnr or vim.api.nvim_get_current_buf() })
end

-- Compat shim: vim.validate old table-form deprecated in 0.10, removed in 1.0
-- Used by bigfile.nvim, legendary.nvim, rustaceanvim, inlay-hints.nvim, lspsaga
-- Converts old form: vim.validate({ name = {val, type, optional?} })
-- to new form: vim.validate(name, val, type, optional?)
do
	local _orig_validate = vim.validate
	vim.validate = function(first, ...)
		if type(first) == "string" then
			return _orig_validate(first, ...)
		end
		if type(first) ~= "table" or select("#", ...) ~= 0 then
			return _orig_validate(first, ...)
		end
		for name, spec in pairs(first) do
			if type(spec) == "table" then
				local t = spec[2]
				if t == "t" then
					t = "table"
				end
				if t == "f" then
					t = "function"
				end
				if t == "s" then
					t = "string"
				end
				if t == "n" then
					t = "number"
				end
				if t == "b" then
					t = "boolean"
				end
				_orig_validate(name, spec[1], t, spec[3])
			end
		end
	end
end
