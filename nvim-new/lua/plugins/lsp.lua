local icons = require("core.icons")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = { enabled = false }, -- user disabled
      codelens = { enabled = false },
      folds = { enabled = true },
      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
              doc = { privateName = { "^_" } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
      setup = {},
    },
    config = vim.schedule_wrap(function(_, opts)
      -- Diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- LSP keymaps via LspAttach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local function bmap(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
          end

          bmap("n", "<leader>cl", function() Snacks.picker.lsp_config() end, "Lsp Info")
          -- fzf-lua overrides for gd/gr/gI/gy (set by fzf-lua plugin)
          bmap("n", "gd", "<cmd>FzfLua lsp_definitions jump1=true ignore_current_line=true<cr>", "Goto Definition")
          bmap("n", "gr", "<cmd>FzfLua lsp_references jump1=true ignore_current_line=true<cr>", "References")
          bmap("n", "gI", "<cmd>FzfLua lsp_implementations jump1=true ignore_current_line=true<cr>", "Goto Implementation")
          bmap("n", "gy", "<cmd>FzfLua lsp_typedefs jump1=true ignore_current_line=true<cr>", "Goto T[y]pe Definition")
          bmap("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          bmap("n", "K", vim.lsp.buf.hover, "Hover")
          bmap("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          bmap("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
          bmap({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          bmap({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
          bmap("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
          bmap("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
          bmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          bmap("n", "<leader>cA", function()
            vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
          end, "Source Action")
        end,
      })

      -- Folds via LSP
      if opts.folds.enabled then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
        end)
      end

      -- Configure * (global) server settings
      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- Get all mason-lspconfig available servers
      local have_mason = pcall(require, "mason-lspconfig")
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {}
      local mason_exclude = {}

      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end

        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts)
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end

      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup({
          ensure_installed = install,
          automatic_enable = { exclude = mason_exclude },
        })
      end
    end),
  },

  -- Mason
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
