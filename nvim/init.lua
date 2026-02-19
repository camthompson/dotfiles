-- Leaders must be set before lazy
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core options before plugins
require("core.options")

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load keymaps and autocmds after plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = function()
    require("core.keymaps")
    require("core.autocmds")
  end,
})

-- Set colorscheme
vim.cmd.colorscheme("catppuccin-mocha")

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
