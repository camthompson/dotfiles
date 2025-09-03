require("config.cam")

-- Hide cursor on dashboard
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  callback = function()
    local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
    hl.blend = 100
    vim.api.nvim_set_hl(0, "Cursor", hl)
    vim.cmd("set guicursor+=a:Cursor/lCursor")
  end,
})

-- Show cursor when dashboard is closed
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

-- Show cursor when entering command mode
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
    hl.blend = 0
    vim.api.nvim_set_hl(0, "Cursor", hl)
    vim.cmd("set guicursor+=a:Cursor/lCursor")
  end,
})
