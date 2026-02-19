local map = vim.keymap.set
local util = require("core.util")

-- ============================================================================
-- From LazyVim defaults (selectively kept)
-- ============================================================================

-- Better up/down on wrapped lines
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- NOTE: <C-h/j/k/l> window nav handled by tmux-navigator plugin

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- NOTE: <A-j>/<A-k> move lines deliberately omitted (user doesn't want them)

-- Buffers
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / Clear hlsearch / Diff Update" })

-- Saner behavior of n and N
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- Quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Format
map({ "n", "x" }, "<leader>cf", function() util.format({ force = true }) end, { desc = "Format" })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Toggle options (via Snacks.toggle)
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }):map("<leader>uc")
Snacks.toggle.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" }):map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- Lazygit
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
  map("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
end

-- Git pickers via Snacks
map("n", "<leader>gL", function() Snacks.picker.git_log() end, { desc = "Git Log (cwd)" })
map("n", "<leader>gb", function() Snacks.picker.git_log_line() end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Current File History" })
map("n", "<leader>gl", function() Snacks.picker.git_log({ cwd = util.git_root() }) end, { desc = "Git Log" })
map({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- Highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function() vim.treesitter.inspect_tree() vim.api.nvim_input("I") end, { desc = "Inspect Tree" })

-- Floating terminal
map("n", "<leader>fT", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
map("n", "<leader>ft", function() Snacks.terminal(nil, { cwd = util.root() }) end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<c-/>", function() Snacks.terminal(nil, { cwd = util.root() }) end, { desc = "Terminal (Root Dir)" })
map({ "n", "t" }, "<c-_>", function() Snacks.terminal(nil, { cwd = util.root() }) end, { desc = "which_key_ignore" })

-- Windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- Tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Lua (only in lua files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(ev)
    vim.keymap.set({ "n", "x" }, "<localleader>r", function() Snacks.debug.run() end, { buffer = ev.buf, desc = "Run Lua" })
  end,
})

-- ============================================================================
-- User custom keymaps
-- ============================================================================

-- Map ]E and [E to go between errors
map("n", "]E", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[E", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })

-- Replace default error maps with unimpaired
map("n", "[e", "<Plug>(unimpaired-move-up)")
map("n", "]e", "<Plug>(unimpaired-move-down)")
map("x", "]e", "<Plug>(unimpaired-move-selection-down)")
map("x", "[e", "<Plug>(unimpaired-move-selection-up)")

-- Swap ; and : in normal and visual modes
map({ "n", "v" }, ";", ":", { desc = "Command mode" })
map({ "n", "v" }, ":", ";", { desc = "Repeat motion" })
map({ "n" }, "q;", "q:", { desc = "Command history" })

-- Bind %% to current buffer directory when writing command
map("c", "%%", function()
  if vim.fn.getcmdtype() == ":" then
    return vim.fn.fnameescape(vim.fn.expand("%:h")) .. "/"
  else
    return "%%"
  end
end, { expr = true })

-- Bind g<cr> to :Gwrite<cr>
map("n", "g<cr>", ":Gwrite<cr>", { desc = "Stage file" })

-- Bind <cr> to :w<cr> in normal mode (except in quickfix)
local function map_cr()
  map("n", "<cr>", function()
    if vim.bo.buftype == "quickfix" then
      return "<cr>"
    else
      return ":w<cr>"
    end
  end, { expr = true })
end

map_cr()

-- Unmap <cr> in command window, restore after leaving
vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function()
    vim.keymap.del("n", "<cr>")
  end,
})

vim.api.nvim_create_autocmd("CmdwinLeave", {
  callback = function()
    map_cr()
  end,
})

-- Navigate to first/last non-blank character
map("n", "H", "g^", { desc = "Go to first non-blank character" })
map("x", "H", "g^", { desc = "Go to first non-blank character" })
map("n", "L", "g_", { desc = "Go to last non-blank character" })
map("x", "L", "g_", { desc = "Go to last non-blank character" })

-- Faster scrolling
map("n", "<c-y>", "5<c-y>", { desc = "Scroll up 5 lines" })
map("n", "<c-e>", "5<c-e>", { desc = "Scroll down 5 lines" })

-- Repeat last substitution with flags
map("n", "&", ":&&<cr>", { desc = "Repeat last substitution with flags" })
map("x", "&", ":&&<cr>", { desc = "Repeat last substitution with flags" })

-- Format paragraph/selection
map("n", "Q", "gqip", { desc = "Format paragraph" })
map("x", "Q", "gq", { desc = "Format selection" })

-- Select line content (excluding whitespace)
map("n", "vv", "^vg_", { desc = "Select line content" })

-- Show previous buffer
map("n", "bp", ":bprevious<cr>", { desc = "Previous buffer" })

-- Sideways
map("n", "ch", ":SidewaysLeft<cr>")
map("n", "cl", ":SidewaysRight<cr>")

-- Yanky
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- vscode-diff
map({ "n" }, "<leader>gr", ":CodeDiff main<cr>", { desc = "CodeDiff main" })

-- Theme toggles
map("n", "<leader>td", ":colorscheme catppuccin-mocha<cr>", { desc = "Theme Dark (Mocha)" })
map("n", "<leader>tl", ":colorscheme catppuccin-latte<cr>", { desc = "Theme Light (Latte)" })
