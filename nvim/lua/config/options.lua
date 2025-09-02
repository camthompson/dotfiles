-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.clipboard = "" -- Don't integrate with system clipboard
opt.relativenumber = false -- Show absolute line numbers

vim.api.nvim_create_autocmd("User", {
  -- Hide cursor on dashboard
  pattern = "SnacksDashboardOpened",
  callback = function()
    local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
    hl.blend = 100
    vim.api.nvim_set_hl(0, "Cursor", hl)
    vim.cmd("set guicursor+=a:Cursor/lCursor")
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardClosed",
  callback = function()
    local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
    hl.blend = 0
    vim.api.nvim_set_hl(0, "Cursor", hl)
    -- vim.opt.guicursor.append("a:Cursor/lCursor")
    vim.cmd("set guicursor+=a:Cursor/lCursor")
  end,
})
