-- FIX 2026-02-13T23:38:09: Treesitter language API compatibility shim moved to init.lua
-- The shim must run before lazy.nvim loads to prevent Telescope previewer errors
-- See init.lua for the enhanced ft_to_lang compatibility shim

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Persist nvim-ufo fold state across saves
-- Formatters (rustfmt, conform) rewrite buffers on :w, destroying manual folds.
-- This saves closed fold start-line content before write and re-closes matching
-- folds after ufo recomputes.
local fold_group = augroup("UfoFoldPersist", { clear = true })
autocmd("BufWritePre", {
	group = fold_group,
	callback = function(args)
		local buf = args.buf
		if vim.bo[buf].buftype ~= "" then
			return
		end
		local closed = {}
		local i = 1
		local line_count = vim.api.nvim_buf_line_count(buf)
		while i <= line_count do
			local fc = vim.fn.foldclosed(i)
			if fc == i then
				local text = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
				if text then
					table.insert(closed, text)
				end
				i = vim.fn.foldclosedend(i) + 1
			else
				i = i + 1
			end
		end
		if #closed > 0 then
			vim.b[buf].ufo_closed_folds = closed
		end
	end,
})
autocmd("BufWritePost", {
	group = fold_group,
	callback = function(args)
		local buf = args.buf
		if vim.bo[buf].buftype ~= "" then
			return
		end
		local closed = vim.b[buf].ufo_closed_folds
		if not closed or #closed == 0 then
			return
		end
		-- Defer to let ufo recompute folds after formatter rewrites
		vim.defer_fn(function()
			if not vim.api.nvim_buf_is_valid(buf) then
				return
			end
			local lookup = {}
			for _, text in ipairs(closed) do
				lookup[text] = true
			end
			local line_count = vim.api.nvim_buf_line_count(buf)
			for i = 1, line_count do
				local text = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
				if text and lookup[text] then
					pcall(vim.cmd, i .. "foldclose")
					lookup[text] = nil
					if not next(lookup) then
						break
					end
				end
			end
			vim.b[buf].ufo_closed_folds = nil
		end, 150)
	end,
})

-- BigFile handling: disable heavy features for files > 512KB
local bigfile_group = augroup("BigFileSettings", { clear = true })
autocmd({ "BufReadPre" }, {
	group = bigfile_group,
	callback = function(args)
		local ok, stat = pcall((vim.uv or vim.loop).fs_stat, args.file)
		if ok and stat and stat.size > 1024 * 512 then
			vim.b.bigfile = true
			vim.b.large_buf = true
			vim.opt_local.spell = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.statuscolumn = ""
		end
	end,
})

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = augroup("NvFilePost", { clear = true }),
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

		if not vim.g.ui_entered and args.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
			vim.api.nvim_del_augroup_by_name("NvFilePost")

			vim.schedule(function()
				vim.api.nvim_exec_autocmds("FileType", {})

				if vim.g.editorconfig then
					require("editorconfig").config(args.buf)
				end
			end)
		end
	end,
})

-- Enable conceallevel for markdown and quarto files to allow render-markdown.nvim to hide syntax
autocmd("FileType", {
	pattern = { "markdown", "quarto", "Avante" },
	callback = function()
		-- Skip if bigfile is detected to prevent UI lag on massive docs
		if vim.b.bigfile or vim.b.large_buf then
			return
		end
		vim.opt_local.conceallevel = 2
		vim.opt_local.concealcursor = "nc" -- hide while not typing in the line
	end,
})

-- FIX 2026-02-17T13:18:55-07:00: Lock core navigation keymaps in LSP-attached buffers.
do
	local augroup = vim.api.nvim_create_augroup("NvLspKeymapsLock", { clear = true })

	local function lsp_hover()
		if vim.fn.exists(":RustLsp") == 2 then
			local ok = pcall(vim.cmd.RustLsp, { "hover", "actions" })
			if ok then
				return
			end
		end

		pcall(vim.lsp.buf.hover)
	end

	local function lock_keymaps(bufnr)
		if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
			return
		end

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, silent = true })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, silent = true })
		vim.keymap.set("n", "K", lsp_hover, { buffer = bufnr, silent = true })

		vim.keymap.set("n", "gk", "gk", { buffer = bufnr, silent = true, noremap = true })
		vim.keymap.set({ "n", "v" }, "gq", "gq", { buffer = bufnr, silent = true, noremap = true })
	end

	local function get_clients(bufnr)
		local fn = vim.lsp.get_clients or vim.lsp.get_active_clients
		if type(fn) ~= "function" then
			return {}
		end
		local ok, clients = pcall(fn, { bufnr = bufnr })
		if ok and type(clients) == "table" then
			return clients
		end
		return {}
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup,
		callback = function(args)
			vim.schedule(function()
				lock_keymaps(args.buf)
			end)
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		group = augroup,
		callback = function(args)
			local bufnr = args.buf
			if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
				return
			end

			local clients = get_clients(bufnr)
			if #clients == 0 then
				return
			end

			vim.schedule(function()
				lock_keymaps(bufnr)
			end)
		end,
	})
end

autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if
			line > 1
			and line <= vim.fn.line("$")
			and vim.bo.filetype ~= "commit"
			and vim.fn.index({ "xxd", "gitrebase" }, vim.bo.filetype) == -1
		then
			vim.cmd('normal! g`"')
		end
	end,
})

autocmd("VimEnter", {
	command = ":silent !bash @ set-spacing padding=0 margin=0",
})

autocmd("VimLeavePre", {
	command = ":silent !bash @ set-spacing padding=20 margin=10",
})
