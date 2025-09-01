-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Swap ; and : in normal and visual modes
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Command mode" })
vim.keymap.set({ "n", "v" }, ":", ";", { desc = "Repeat motion" })

-- Bind <cr> to :up<cr> in normal mode
vim.keymap.set("n", "<cr>", ":up<cr>", { desc = ":up" })

-- Bind <leader>d to delete buffer in normal mode
vim.keymap.set("n", "<leader>d", ":bdelete<cr>", { desc = "Delete buffer" })
