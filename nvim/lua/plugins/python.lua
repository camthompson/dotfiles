return {
  -- Configure Python LSP with diagnostics disabled
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable these LSPs
        pyright = false,
        pylsp = false,
        ruff_lsp = false,
        ruff = false,
        -- Enable basedpyright with diagnostics disabled
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

  -- Ensure basedpyright is installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "ruff",
      },
    },
  },

  -- Configure formatting with ruff
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { "ruff_format" }

      opts.formatters = opts.formatters or {}
      opts.formatters.ruff_format = {
        command = "ruff",
        args = function()
          local root = vim.fn.getcwd()
          return { "format", "--config", root .. "/src/pyproject.toml", "--stdin-filename", "$FILENAME", "-" }
        end,
        stdin = true,
      }
      return opts
    end,
  },

  -- Configure linting with mypy
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "mypy_cluster" },
      },
      linters = {
        mypy_cluster = {
          cmd = "/Users/cam/work/gemyn/mypy.sh",
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
                -- Normalize container path to local path for comparison
                -- Container: //opt/gemyn/src/api/...
                -- Local: /Users/cam/work/gemyn/src/api/...
                local normalized_file = file:gsub("^//opt/gemyn/", root .. "/")

                -- Only include diagnostics for the current file
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
