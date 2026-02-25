return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "typescript", "tsx", "javascript" },
    },
  },

  -- LSP: vtsls
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
      },
    },
  },

  -- Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "vtsls" },
    },
  },

  -- Formatting with oxfmt
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
      },
      formatters = {
        oxfmt = {
          command = "npx",
          args = { "oxfmt", "$FILENAME" },
          stdin = false,
          condition = function(self, ctx)
            return vim.fs.find(".oxfmtrc.json", { path = ctx.dirname, upward = true })[1] ~= nil
          end,
        },
      },
    },
  },

  -- Linting with oxlint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        javascript = { "oxlint" },
        javascriptreact = { "oxlint" },
        typescript = { "oxlint" },
        typescriptreact = { "oxlint" },
      },
      linters = {
        oxlint = {
          cmd = "npx",
          args = { "oxlint", "--format", "unix" },
          stdin = false,
          stream = "stdout",
          ignore_exitcode = true,
          parser = require("lint.parser").from_pattern(
            "([^:]+):(%d+):(%d+): (.+)",
            { "file", "lnum", "col", "message" },
            nil,
            { severity = vim.diagnostic.severity.WARN }
          ),
        },
      },
    },
  },
}
