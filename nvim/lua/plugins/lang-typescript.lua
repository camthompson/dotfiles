return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "typescript", "tsx", "javascript" },
    },
  },

  -- LSP: vtsls (default) or tsgo (set vim.g.ts_lsp = "tsgo" to use)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local ts_lsp = vim.g.ts_lsp or "vtsls"
      opts.servers = opts.servers or {}

      if ts_lsp == "tsgo" then
        opts.servers.tsgo = {
          settings = {
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = {
                  enabled = "literals",
                  suppressWhenArgumentMatchesName = true,
                },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        }
        -- Disable vtsls when using tsgo
        opts.servers.vtsls = { enabled = false }
      else
        opts.servers.vtsls = {
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
        }
      end
    end,
  },

  -- Mason
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "vtsls", "oxfmt" },
    },
  },

  -- Linting with oxlint (native LSP)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        oxlint = {
          settings = {
            fixKind = "all",
          },
        },
      },
    },
  },

  -- Formatting with oxfmt (Mason-installed, conform built-in)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "oxfmt" },
        javascriptreact = { "oxfmt" },
        typescript = { "oxfmt" },
        typescriptreact = { "oxfmt" },
      },
    },
  },
}
