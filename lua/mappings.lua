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
map("n", "<leader>jd", "<cmd>RustMoveItemDown<CR>^n", { desc = "Rust move line down" })
map("n", "<leader>ju", "<cmd>RustMoveItemUp<CR>^n", { desc = "Rust move line up" })

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
    vim.cmd "highlight LineHighlight ctermbg=220 guibg=#e5c07b"
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

-- cloak toggles
map("n", "<leader>uc", "<cmd>CloakToggle<CR>", { silent = true, desc = "Toggle Cloak" })
map("n", "<leader>ue", "<cmd>CloakEnable<CR>", { silent = true, desc = "Enable Cloak" })
map("n", "<leader>ud", "<cmd>CloakDisable<CR>", { silent = true, desc = "Disable Cloak" })
map("n", "<leader>up", "<cmd>CloakPreviewLine<CR>", { silent = true, desc = "Preview Cloak Line" })

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
local nvterm_ok, nvterm = pcall(require, "nvchad.term")
if nvterm_ok then
  map("n", "<leader>h", function()
    nvterm.new { pos = "sp" }
  end, { desc = "terminal new horizontal term" })
  map("n", "<leader>v", function()
    nvterm.new { pos = "vsp" }
  end, { desc = "terminal new vertical window" })

  -- toggleable
  map({ "n", "t" }, "<A-v>", function()
    nvterm.toggle { pos = "vsp", id = "vtoggleTerm" }
  end, { desc = "terminal toggleable vertical term" })
end

map({ "n", "t" }, "<A-f>", function()
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
  map("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Lazygit (Floating)" })

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

-- Lspsaga: unified LSP UI mappings
map("n", "<C-k>", "<cmd>Lspsaga hover_doc<CR>", { silent = true, desc = "Lspsaga hover doc" })
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true, desc = "Lspsaga code action" })
map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "Lspsaga rename symbol" })
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, desc = "Lspsaga prev diagnostic" })
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, desc = "Lspsaga next diagnostic" })
map("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, desc = "Lspsaga line diagnostics" })

-- Crates.nvim
local crates_ok, crates = pcall(require, "crates")
if crates_ok then
  map("n", "<leader>cv", function() crates.show_versions_popup() end, { desc = "Crates show versions" })
  map("n", "<leader>cR", function() crates.show_features_popup() end, { desc = "Crates show features" })
  map("n", "<leader>cu", function() crates.update_crate() end, { desc = "Crates update" })
  map("n", "<leader>cU", function() crates.upgrade_crate() end, { desc = "Crates upgrade" })
  map("n", "<leader>cH", function() crates.open_homepage() end, { desc = "Crates open homepage" })
  map("n", "<leader>cD", function() crates.open_documentation() end, { desc = "Crates open documentation" })
end

-- YAML Companion
map("n", "<leader>ys", function()
  local ok, companion = pcall(require, "yaml-companion")
  if ok then
    companion.open_ui_select()
  end
end, { desc = "YAML select schema" })

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

-- DAP keymaps
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "DAP: Toggle breakpoint" })
map("n", "<leader>dr", "<cmd>lua require'dap'.continue()<CR>", { desc = "DAP: Start/Continue" })
map("n", "<leader>di", "<cmd>lua require'dap'.step_into()<CR>", { desc = "DAP: Step into" })
map("n", "<leader>do", "<cmd>lua require'dap'.step_over()<CR>", { desc = "DAP: Step over" })
map("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<CR>", { desc = "DAP: Step out" })
map("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<CR>", { desc = "DAP: Terminate" })
map("n", "<leader>dw", "<cmd>lua require'dap.ui.widgets'.hover()<CR>", { desc = "DAP: Hover widgets" })
map("n", "<leader>dui", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "DAP: Toggle UI" })
map("n", "<leader>dx", "<cmd>lua require'dap'.terminate()<CR>", { desc = "DAP: Terminate (Toggle)" })

-- code action (Lspsaga)
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "LSP code action" })
map("n", "<C-Space>", "<cmd>Lspsaga code_action<CR>", { silent = true, desc = "LSP code action" })
map("v", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true, desc = "LSP code action (visual)" })
map("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "LSP Rename (Lspsaga)" })
map("n", "<leader>cf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { silent = true, desc = "LSP Format buffer" })

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

-- source/reload config
map("n", "<leader>sv", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, { desc = "Source/reload config" })

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
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
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

-- code fold (nvim-ufo — docs require remapping zR/zM to ufo API)
map("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
map("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
map("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Open folds except kinds" })
map("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Close folds with" })
map("n", "zk", function() require("ufo").peekFoldedLinesUnderCursor() end, { desc = "Peek folded lines" })

-- nvim-surround: setup and keymaps live in lua/plugins/nvim_surround.lua
-- Default keys: ys<motion><char>  cs<old><new>  ds<char>  (visual) S<char>

-- global lsp mappings (keep minimal; Lspsaga handles most UI)
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
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics" })
map("n", "<leader>tx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Trouble diagnostics (alt)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Trouble buffer diagnostics" })
map("n", "<leader>xo", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Trouble symbols" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "Trouble LSP" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Trouble location list" })
map("n", "<leader>xQ", "<cmd>Trouble quickfix toggle<cr>", { desc = "Trouble quickfix" })
map("n", "<leader>xr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "Trouble LSP references" })

-- neotest
map("n", "<leader>tt", function() require("neotest").run.run() end, { desc = "Run nearest test" })
map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run file tests" })
map("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle test summary" })

-- dadbod ui
map("n", "<leader>du", "<cmd>DBUIToggle<cr>", { desc = "Toggle DB UI" })

-- neogit
map("n", "<leader>gn", "<cmd>Neogit<cr>", { desc = "Neogit" })

-- kulala
map("n", "<leader>rq", function()
  local ft = vim.bo.filetype
  local ext = vim.fn.expand("%:e")
  if ft == "http" or ft == "rest" or ext == "http" or ext == "rest" or ext == "https" then
    if ft ~= "http" and ft ~= "rest" then vim.bo.filetype = "http" end
    require("kulala").run()
  else
    vim.notify("Kulala only runs in .http, .https, or .rest files", vim.log.levels.WARN)
  end
end, { desc = "Run HTTP Request" })
map("n", "<leader>rt", function()
  local ft = vim.bo.filetype
  local ext = vim.fn.expand("%:e")
  if ft == "http" or ft == "rest" or ext == "http" or ext == "rest" or ext == "https" then
    if ft ~= "http" and ft ~= "rest" then vim.bo.filetype = "http" end
    require("kulala").toggle_view()
  else
    vim.notify("Kulala only runs in .http, .https, or .rest files", vim.log.levels.WARN)
  end
end, { desc = "Toggle Headers/Body View" })

-- grug-far
map("n", "<leader>sr", function()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and replace (GrugFar)" })

-- todo-comments
map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
map("n", "<leader>st", "<cmd>TodoTelescope<CR>", { desc = "Search todo comments" })
map("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "Trouble todo comments" })

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

-- Scratchpad
map("n", "<leader>sn", "<cmd>Scratch<CR>", { desc = "New scratch by type" })
map("n", "<leader>sh", vim.lsp.buf.signature_help, { desc = "Show signature help" })
map("n", "<leader>sa", function() require("nvim-treesitter.textobjects.swap").swap_next("@parameter.inner") end, { desc = "Swap next argument" })
map("n", "<leader>sA", function() require("nvim-treesitter.textobjects.swap").swap_previous("@parameter.inner") end, { desc = "Swap prev argument" })
map("n", "<leader>sw", "<cmd>ScratchWithName<CR>", { desc = "New scratch with name" })
map("n", "<leader>so", "<cmd>ScratchOpen<CR>", { desc = "Open scratch list" })
map("n", "<leader>sc", "<cmd>Scratch<CR>", { desc = "New scratch by type" })

-- Markdown & Mermaid
map("n", "<leader>um", "<cmd>RenderMarkdown toggle<CR>", { desc = "Toggle Markdown Render" })
map("n", "<leader>lp", "<cmd>LivePreview<CR>", { desc = "Toggle Live Preview (Mermaid/Markdown)" })
map("n", "<leader>ls", "<cmd>LivePreviewStop<CR>", { desc = "Stop Live Preview" })

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
