-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map ]E and [E to go between errors
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "]E", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[E", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })

-- Replace LazyVim error maps with unimpaired
vim.keymap.set("n", "[e", "<Plug>(unimpaired-move-up)")
vim.keymap.set("n", "]e", "<Plug>(unimpaired-move-down)")
vim.keymap.set("x", "]e", "<Plug>(unimpaired-move-selection-down)")
vim.keymap.set("x", "[e", "<Plug>(unimpaired-move-selection-up)")

-- Swap ; and : in normal and visual modes
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Command mode" })
vim.keymap.set({ "n", "v" }, ":", ";", { desc = "Repeat motion" })
vim.keymap.set({ "n" }, "q;", "q:", { desc = "Command history" })

-- Bind <leader>d to delete buffer in normal mode
vim.keymap.set("n", "<leader>d", ":bdelete<cr>", { desc = "Delete buffer" })

-- Bind %% to current buffer directory when writing command
vim.keymap.set("c", "%%", function()
  if vim.fn.getcmdtype() == ":" then
    return vim.fn.fnameescape(vim.fn.expand("%:h")) .. "/"
  else
    return "%%"
  end
end, { expr = true })

-- Bind g<cr> to :Gwrite<cr>
vim.keymap.set("n", "g<cr>", ":Gwrite<cr>", { desc = "Stage file" })

-- Bind <cr> to :w<cr> in normal mode (except in quickfix)
local function map_cr()
  vim.keymap.set("n", "<cr>", function()
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
vim.keymap.set("n", "H", "g^", { desc = "Go to first non-blank character" })
vim.keymap.set("x", "H", "g^", { desc = "Go to first non-blank character" })
vim.keymap.set("n", "L", "g_", { desc = "Go to last non-blank character" })
vim.keymap.set("x", "L", "g_", { desc = "Go to last non-blank character" })

-- Faster scrolling
vim.keymap.set("n", "<c-y>", "5<c-y>", { desc = "Scroll up 5 lines" })
vim.keymap.set("n", "<c-e>", "5<c-e>", { desc = "Scroll down 5 lines" })

-- Repeat last substitution with flags
vim.keymap.set("n", "&", ":&&<cr>", { desc = "Repeat last substitution with flags" })
vim.keymap.set("x", "&", ":&&<cr>", { desc = "Repeat last substitution with flags" })

-- Format paragraph/selection
vim.keymap.set("n", "Q", "gqip", { desc = "Format paragraph" })
vim.keymap.set("x", "Q", "gq", { desc = "Format selection" })

-- Select line content (excluding whitespace)
vim.keymap.set("n", "vv", "^vg_", { desc = "Select line content" })

-- Show previous buffer
vim.keymap.set("n", "<c-p>", ":bprevious<cr>", { desc = "Previous buffer" })

-- Unmap <M-j> and <M-k> in normal mode
-- This handles an annoying problem where <esc> and then j or k too quickly reorders lines
vim.keymap.del("n", "<M-j>")
vim.keymap.del("n", "<M-k>")
