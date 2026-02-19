return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ninja", "rst" },
    },
  },

  -- LSP: basedpyright with diagnostics disabled
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { enabled = false },
        pylsp = { enabled = false },
        ruff_lsp = { enabled = false },
        ruff = { enabled = false },
        basedpyright = {
          on_attach = function(client, _)
            client.server_capabilities.diagnosticProvider = false
          end,
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "off",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
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
      ensure_installed = {
        "basedpyright",
        "ruff",
      },
    },
  },

  -- Formatting with ruff
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
      formatters = {
        ruff_format = {
          command = "ruff",
          args = function()
            local root = vim.fn.getcwd()
            return { "format", "--config", root .. "/src/pyproject.toml", "--stdin-filename", "$FILENAME", "-" }
          end,
          stdin = true,
        },
      },
    },
  },

  -- Linting with mypy
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "mypy_cluster" },
      },
      linters = {
        mypy_cluster = {
          cmd = function()
            return vim.fn.getcwd() .. "/mypy.sh"
          end,
          stdin = false,
          append_fname = false,
          args = {},
          stream = "both",
          ignore_exitcode = true,
          parser = function(output, bufnr)
            local diagnostics = {}
            local current_file = vim.api.nvim_buf_get_name(bufnr)
            local root = vim.fn.getcwd()

            for line in output:gmatch("[^\r\n]+") do
              local file, lnum, severity, msg = line:match("^(.+):(%d+): (%w+): (.+)$")
              if file and lnum then
                local normalized_file = file:gsub("^//opt/gemyn/", root .. "/")
                if normalized_file == current_file then
                  local sev = severity == "error" and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN
                  table.insert(diagnostics, {
                    lnum = tonumber(lnum) - 1,
                    col = 0,
                    severity = sev,
                    message = msg,
                    source = "mypy",
                  })
                end
              end
            end
            return diagnostics
          end,
        },
      },
    },
  },
}
