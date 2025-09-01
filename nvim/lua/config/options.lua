-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.clipboard = "" -- Don't integrate with system clipboard
opt.relativenumber = false -- Show absolute line numbers

vim.g.lazyvim_python_lsp = "basedpyright"
