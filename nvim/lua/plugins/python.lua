return {
  -- Completely disable all Python language servers
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Disable all Python language servers
      opts.servers = opts.servers or {}
      opts.servers.basedpyright = false
      opts.servers.pyright = false
      opts.servers.pylsp = false
      opts.servers.jedi_language_server = false
      opts.servers.ruff = false
      opts.servers.ruff_lsp = false

      -- Also prevent setup if they somehow get through
      opts.setup = opts.setup or {}
      opts.setup.basedpyright = function()
        return true
      end
      opts.setup.pyright = function()
        return true
      end
      opts.setup.pylsp = function()
        return true
      end
      opts.setup.jedi_language_server = function()
        return true
      end
      opts.setup.ruff = function()
        return true
      end
      opts.setup.ruff_lsp = function()
        return true
      end

      return opts
    end,
  },
  -- Disable venv-selector which might trigger LSP setup
  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
  },
  -- Ensure Mason doesn't install Python LSPs
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Add ruff for formatting
      vim.list_extend(opts.ensure_installed, { "ruff" })

      -- Remove any Python LSPs from ensure_installed
      local python_lsps =
        { "basedpyright", "pyright", "pylsp", "python-lsp-server", "jedi-language-server", "ruff-lsp" }
      for i = #opts.ensure_installed, 1, -1 do
        for _, lsp in ipairs(python_lsps) do
          if opts.ensure_installed[i] == lsp then
            table.remove(opts.ensure_installed, i)
            break
          end
        end
      end

      return opts
    end,
  },
  -- Configure Ruff for formatting only
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
      },
    },
  },
  -- Disable Python linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = {},
      },
    },
  },
  -- Override LazyVim Python extra to disable LSPs
  {
    "LazyVim/LazyVim",
    optional = true,
    opts = function(_, opts)
      -- Disable Python LSP in LazyVim
      vim.g.lazyvim_python_lsp = false
      vim.g.lazyvim_python_ruff = false
      return opts
    end,
  },
}

