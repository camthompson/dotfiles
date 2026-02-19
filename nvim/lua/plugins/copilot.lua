return {
  -- Native copilot LSP (Neovim >= 0.12)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        copilot = {},
      },
      setup = {
        copilot = function()
          vim.lsp.enable("copilot")
          vim.schedule(function()
            vim.lsp.inline_completion.enable()
          end)
          vim.keymap.set({ "i", "n" }, "<M-]>", function()
            vim.lsp.inline_completion.select({ count = 1 })
          end, { desc = "Next Copilot Suggestion" })
          vim.keymap.set({ "i", "n" }, "<M-[>", function()
            vim.lsp.inline_completion.select({ count = -1 })
          end, { desc = "Prev Copilot Suggestion" })
          return true
        end,
      },
    },
  },
}
