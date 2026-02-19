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

  -- Copilot/sidekick status in lualine
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      if not opts.sections or not opts.sections.lualine_x then
        return
      end
      local sk_icons = {
        Error = { " ", "DiagnosticError" },
        Inactive = { " ", "MsgArea" },
        Warning = { " ", "DiagnosticWarn" },
        Normal = { " ", "Special" },
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local status = require("sidekick.status").get()
          return status and vim.tbl_get(sk_icons, status.kind, 1)
        end,
        cond = function()
          return package.loaded["sidekick"] and require("sidekick.status").get() ~= nil
        end,
        color = function()
          local status = require("sidekick.status").get()
          local hl = status and (status.busy and "DiagnosticWarn" or vim.tbl_get(sk_icons, status.kind, 2))
          return { fg = Snacks.util.color(hl) }
        end,
      })
    end,
  },
}
