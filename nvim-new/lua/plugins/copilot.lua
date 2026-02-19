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
          local status = require("core.util").copilot_status
          vim.lsp.config("copilot", {
            handlers = {
              didChangeStatus = function(err, res, ctx)
                if err then
                  return
                end
                status[ctx.client_id] = res.kind ~= "Normal" and "error"
                  or res.busy and "pending"
                  or "ok"
              end,
            },
          })
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
