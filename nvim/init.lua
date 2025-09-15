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

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = true,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax", "catppuccin" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

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

-- Set colorscheme
vim.cmd.colorscheme("catppuccin-mocha")
