return {
  "stevearc/conform.nvim",
  dependencies = { "mason.nvim" },
  lazy = true,
  cmd = "ConformInfo",
  event = { "BufWritePre" },
  keys = {
    {
      "<leader>cF",
      function()
        require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
      end,
      mode = { "n", "x" },
      desc = "Format Injected Langs",
    },
  },
  opts = {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    format_on_save = function(bufnr)
      local baf = vim.b[bufnr].autoformat
      if baf ~= nil then
        if not baf then
          return
        end
      elseif vim.g.autoformat == false then
        return
      end
      return { timeout_ms = 3000, lsp_format = "fallback" }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      fish = { "fish_indent" },
      sh = { "shfmt" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
  },
}
