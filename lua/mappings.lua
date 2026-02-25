require "nvchad.mappings"

local utils = require "configs.utils"
local map = utils.glb_map
-- local map = vim.keymap.set
local silent = { silent = true }

-- Line lead char toggle
local line_lead_char_enabled = true
vim.api.nvim_create_user_command("LineLeadCharToggle", function()
  line_lead_char_enabled = not line_lead_char_enabled
  if line_lead_char_enabled then
    vim.opt.list = true
    print("Line lead chars enabled")
  else
    vim.opt.list = false
    print("Line lead chars disabled")
  end
end, { desc = "Toggle line lead characters" })

map("n", ";", ":", { desc = "CMD enter command mode" })
-- The key-bindings here "i" allows to hold down the "Ctrl" key ot move around in 
-- "insert mode" without using the arrow keys
map("i", "jj", "<ESC>")
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>^i", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })
map("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "lsp signature help" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })
map("n", "<C-d>", "<cmd>RustMoveItemDown<CR>^n", { desc = "Rust move line down" })
map("n", "<C-u>", "<cmd>RustMoveItemUp<CR>^n", { desc = "Rust move line up" })
map("n", "<C-k>", vim.lsp.buf.hover, { desc = "lsp hover info" })

-- highlight line toggle
local function toggle_highlight()
  local line_num = vim.fn.line "."
  local highlight_group = "LineHighlight"

  -- Get all matches
  local matches = vim.fn.getmatches()

  local match_id = nil

  -- Check if there's already a match for the current line
  for _, match in ipairs(matches) do
    if match.group == highlight_group and match.pattern == "\\%" .. line_num .. "l" then
      match_id = match.id
      break
    end
  end

  if match_id then
    -- Remove the existing match
    vim.fn.matchdelete(match_id)
    print "Line highlight removed"
  else
    -- Add a new highlight
    vim.cmd "highlight LineHighlight ctermbg=22 guibg=#3a5f3a"
    vim.fn.matchadd("LineHighlight", "\\%" .. line_num .. "l")
    print "Line highlighted"
  end
end
map("n", "<leader>ha", toggle_highlight, { desc = "Toggle Highlight Line" })
map("n", "<leader>hr", "<cmd>call clearmatches()<CR>", { desc = "Clear All Highlights" })

-- nohl search clear
map("n", "<leader>ho", "<cmd>nohl<CR>", { silent = true, desc = "Clear Search Highlight" })

-- inlay-hints toggle
map("n", "<leader>uh", "<cmd>ToggleInlayHints<CR>", { silent = true, desc = "Toggle inlay hints" })

-- Toggle Leading Chars on Lines
-- LineLeadCharToggle
map(
  { "n", "t", "i" },
  "<leader>ul",
  "<cmd>LineLeadCharToggle<CR>",
  { silent = true, desc = "Toggle Line-Lead Char" }
)

-- Toggle Bufline
map({ "n", "t" }, "<leader>ut", "<cmd>TabuflineToggle<CR>", { silent = true, desc = "Toggle Buffer Line" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })
map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })


map({ "n", "t" }, "<A-f>", function()
  require("FTerm").toggle()
end, { desc = "terminal toggle floating term" })

map({ "n", "t" }, "<A-i>", function()
  require("FTerm").toggle()
end, { desc = "terminal toggle floating term" })

map({ "n", "t" }, "<A-h>", function()
  vim.cmd("ToggleTerm direction=horizontal size=15")
end, { desc = "terminal toggleable horizontal term" })

-- Toggle terminal with lazygit, node, python (requires toggleterm)
local toggleterm_ok, _ = pcall(require, "toggleterm")
if toggleterm_ok then
  local Terminal = require("toggleterm.terminal").Terminal
  
  local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })
  _G._LAZYGIT_TOGGLE = function()
    lazygit:toggle()
  end
  map({ "n", "t", "i" }, "<A-l>", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit Terminal" })

  local node = Terminal:new({ cmd = "node", hidden = true })
  _G._NODE_TOGGLE = function()
    node:toggle()
  end
  map({ "n", "t", "i" }, "<A-o>", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Node Terminal" })

  local python = Terminal:new({ cmd = "python3", hidden = true })
  _G._PYTHON_TOGGLE = function()
    python:toggle()
  end
  map({ "n", "t", "i" }, "<A-p>", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Python Terminal" })

  local mini_term = Terminal:new({ hidden = true })
  _G._MINI_TERM = function()
    mini_term:toggle()
  end

  local new_term = Terminal:new({ hidden = true })
  _G._NEW_TERM = function()
    new_term:toggle()
  end
end


-- -- vim sourround
-- map({ "n", "v"}, "<leader>sa", function()
--   require("nvim-surround").add()
-- end, { desc = "surround add" })
--
-- map({ "n", "v"}, "<leader>sd", function()
--   require("nvim-surround").delete()
-- end, { desc = "surround delete" })
--
-- map({ "n", "v"}, "<leader>sc", function()
--   require("nvim-surround").change()
-- end, { desc = "surround change" })

-- carbon-now create share beautiful images of source code
map({ "v", "n", "i" }, "<leader>cn", ":CarbonNow<CR>", { desc = "CarbonNow code-snipper", silent = true })

-- Lspsaga
map("n", "<C-k>", vim.lsp.buf.hover, { silent = true, desc = "lsp hover info" })

-- thePrimeagen's Harpoon
local harpoon_ok, _ = pcall(require, "harpoon")
if harpoon_ok then
  local mark = require "harpoon.mark"
  local ui = require "harpoon.ui"
  map("n", "<C-a>", mark.add_file, { desc = "Harpoon add file" })
  map("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon toggle menu" })
end

-- Hop navigation
local hop_ok, hop = pcall(require, "hop")
if hop_ok then
  hop.setup({})
  map("n", "<leader>hw", "<cmd>HopWord<CR>", { desc = "Hop Word" })
  map("n", "<leader>hl", "<cmd>HopLine<CR>", { desc = "Hop Line" })
  map("n", "<leader>hc", "<cmd>HopChar1<CR>", { desc = "Hop Char1" })
  map("n", "<leader>hC", "<cmd>HopChar2<CR>", { desc = "Hop Char2" })
end

-- Hop keymaps (alternative direct commands)
map("n", "s", "<cmd>HopWord<CR>", { desc = "Hop to word" })

-- Persistence session mappings
local persistence_ok, persistence = pcall(require, "persistence")
if persistence_ok then
  map("n", "<leader>qs", function() persistence.load() end, { desc = "Restore Session" })
  map("n", "<leader>ql", function() persistence.load({ last = true }) end, { desc = "Restore Last Session" })
  map("n", "<leader>qd", function() persistence.stop() end, { desc = "Don't Save Current Session" })
end

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- code action
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "lsp code action" })
map("n", "<C-Space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", silent)
map("v", "<leader>ca", "<cmd>'<,'>lua vim.lsp.buf.code_action()<CR>", silent)
map("n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", silent)
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", silent)

-- open url / go to GitHub link
map("n", "gh", function()
  utils.go_to_github_link()
end, { desc = "Go to GitHub link generated from string" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>i", vim.show_pos, { desc = "Inspect Pos" })
end

-- toggler alternate
map(
  { "n", "v" },
  "<leader>ta",
  "<cmd>lua require('alternate-toggler').toggleAlternate()<CR>",
  { silent = true, desc = "Toggle alternate text/symbol" }
)

-- yank and everything about it
map({ "n", "v" }, "y", '"+y', { desc = "Yank selection" })
map("n", "Y", '"+y$', { desc = "Yank up to EOL" })
map({ "n", "v" }, "yy", '"+yy', { desc = "Yank line" })
map({ "n", "v" }, "p", '"+p', { desc = "Paste below" })
map({ "n", "v" }, "P", '"+P', { desc = "Paste above" })
map({ "n", "v" }, "<C-y>", '"+y', { desc = "Yank into system clipboard" })
map("n", "<C-Y>", '"+y$', { desc = "Yank up to EOL into system clipboard" })
map({ "n", "v" }, "<C-yy>", '"+yy', { desc = "Yank line into system clipboard" })
map({ "n", "v" }, "<C-p>", '"+p', { desc = "Paste below from system clipboard" })
map({ "n", "v" }, "<C-P>", '"+P', { desc = "Paste above from system clipboard" })

-- plugin management
map('n', '<leader>pc', ':Lazy check<cr>', { desc = 'Check plugins' })
map('n', '<leader>pu', ':Lazy update<cr>', { desc = 'Update plugins' })
map('n', '<leader>ps', ':Lazy show<cr>', { desc = 'Show plugins' })
map('n', '<leader>ph', ':Lazy help<cr>', { desc = 'Help' })
map('n', '<leader>pp', ':Lazy profile<cr>', { desc = 'Profile' })
map('n', '<leader>px', ':Lazy clear<cr>', { desc = 'Clear uninstalled plugins' })
map('n', '<leader>pr', ':Lazy restore<cr>', { desc = 'Restore plugins from lockfile' })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- blankline
map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
map("n", "<leader>th", function()
  if type(_G._apply_ft_to_lang_shim) == "function" then
    pcall(_G._apply_ft_to_lang_shim)
  end

  if type(_G._nvchad_open_themes_picker) ~= "function" then
    pcall(require, "chadrc")
  end

  if type(_G._nvchad_open_themes_picker) == "function" then
    _G._nvchad_open_themes_picker()
  else
    pcall(vim.cmd, "Telescope themes")
  end
end, { desc = "telescope nvchad themes" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)

-- code fold 
local ufo_ok, ufo = pcall(require, "ufo")
if ufo_ok then
  map("n", "zR", ufo.openAllFolds)
  map("n", "zM", ufo.closeAllFolds)
  map("n", "zr", ufo.openFoldsExceptKinds)
  map("n", "zm", ufo.closeFoldsWith)
  map("n", "zk", ufo.peekFoldedLinesUnderCursor)
end

-- -- nvim-surround
-- map("n", "<leader>sa", require("nvim-surround").add_surround, { desc = "nvchad surround add" })
-- map("n", "<leader>sd", require("nvim-surround").delete_surround, { desc = "nvchad surround delete" })
-- map("n", "<leader>sc", require("nvim-surround").change_surround, { desc = "nvchad surround change" })
--
-- NOTE: nvim-surround setup moved to plugin config in lua/plugins/init.lua
-- to avoid loading issues during mappings initialization
-- FIX 2026-02-13T23:15:58: Removed require("nvim-surround").setup() call
-- that was causing issues during mappings load
local surround_ok, nvim_surround = pcall(require, "nvim-surround")
if surround_ok then
  nvim_surround.setup({
    surrounds = {
        -- ["h"] = false,
    },
    keymaps = {
      insert = "<C-g>s",
      insert_line = "<C-g>S",
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      visual = "ms",
      visual_line = "gS",
      delete = "ds",
      change = "cs",
      change_line = "cS",
    },
  })
end

-- global lsp mappings
map("n", "<leader>dss", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })


-- Comment
map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })

-- NvimTree Focus Window
map({ "n", "t" }, "<A-n>", "<cmd>NvimTreeToggle<CR>", { desc = "toggle NvimTree focus window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "open NvimTree focus window" })

-- Auto resize panes when resizing nvim window
-- ...

vim.opt.list = true

for i = 1, 9, 1 do
  -- Move to desired buffer line using Alt + 1-9 keys
  vim.keymap.set("n", string.format("<A-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufsic)
  end, { desc = "which_key_ignore" })
  -- Move to desired tab group instantly using Leader + 1-9 keys
  vim.keymap.set("n", string.format("<leader>%s", i), function()
    vim.api.nvim_set_current_tabpage(i)
  end, { desc = "which_key_ignore" })
end

-- zen mode
map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode" })

-- trouble diagnostics
map("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
map("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics (alt)" })
map("n", "<leader>tX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble buffer diagnostics" })
map("n", "<leader>to", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble symbols" })
map("n", "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble LSP" })
map("n", "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble location list" })
map("n", "<leader>tQ", "<cmd>Trouble quickfix toggle<cr>", { desc = "Trouble quickfix" })
map("n", "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "Trouble LSP references" })

-- treesj split/join (<space>m/j/s in plugin spec = <leader>m/j/s)
map("n", "<leader>m", "<cmd>TSJToggle<cr>", { desc = "Split/join toggle" })
map("n", "<leader>j", "<cmd>TSJSplit<cr>", { desc = "Split code block" })
map("n", "<leader>s", "<cmd>TSJJoin<cr>", { desc = "Join code block" })

-- activate.nvim plugin browser
map("n", "<leader>P", function()
  local ok, activate = pcall(require, "activate")
  if ok then activate.list_plugins() end
end, { desc = "List plugins (activate)" })
map("n", "<leader>pP", function()
  local ok, activate = pcall(require, "activate")
  if ok then activate.list_plugins() end
end, { desc = "List plugins (activate)" })

-- duplicate lines (legendary + duplicate.nvim)
map("n", "<leader>lu", ":LineDuplicate -1<CR>", { desc = "Duplicate line up" })
map("n", "<leader>ld", ":LineDuplicate +1<CR>", { desc = "Duplicate line down" })
map("v", "<leader>ls", ":VisualDuplicate -1<CR>", { desc = "Duplicate selection up" })
map("v", "<leader>lt", ":VisualDuplicate +1<CR>", { desc = "Duplicate selection down" })

--
-- ---@meta

-- ---@class ApiKeymapOpts
-- ---@field nowait? boolean If true, once the `lhs` is matched, the `rhs` will be executed
-- ---@field expr? boolean Specify whether the `rhs` is an expression to be evaluated or not (default false)
-----@field silent? boolean Specify whether `rhs` will be echoed on the command line
-----@field unique? boolean Specify whether not to map if there exists a keymap with the same `lhs`
-----@field script? boolean
-----@field desc? string Description for what the mapping will do
-----@field noremap? boolean Specify whether the `rhs` will execute user-defined keymaps if it matches some `lhs` or not
-----@field replace_keycodes? boolean Only effective when `expr` is **true**, specify whether to replace keycodes in the resuling string
-----@field callback function Lua function to call when the mapping is executed

-----@alias VimKeymapMode
-----|'"n"' # Normal Mode
-----|'"x"' # Visual Mode Keymaps
-----|'"s"' # Select Mode
-----|'"v"' # Equivalent to "xs"
-----|'"o"' # Operator-pending mode
-----|'"i"' # Insert Mode
-----|'"c"' # Command-Line Mode
-----|'"l"' # Insert, Command-Line and Lang-Arg
-----|'"t"' # Terminal Mode
-----|'"!"' # Equivalent to Vim's `:map!`, which is equivalent to '"ic"'
-----|'""'  # Equivalent to Vim's `:map`, which is equivalent to "nxso"

-----@class NvKeymapOpts : ApiKeymapOpts
-----@field remap? boolean inverse of `noremap`
-----@field buffer? integer|boolean|nil Specify the buffer that the keymap will be effective in. If 0 or true, the current buffer will be used
