return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.events = { "BufWritePost", "BufReadPost" }
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.javascript = { "oxlint" }
    opts.linters_by_ft.javascriptreact = { "oxlint" }
    opts.linters_by_ft.typescript = { "oxlint" }
    opts.linters_by_ft.typescriptreact = { "oxlint" }

    local lint = require("lint")
    lint.linters.oxlint = {
      cmd = "oxlint",
      args = { "--format", "unix" },
      stdin = false,
      stream = "stdout",
      ignore_exitcode = true,
      parser = require("lint.parser").from_pattern(
        "([^:]+):(%d+):(%d+): (.+)",
        { "file", "lnum", "col", "message" },
        nil,
        { severity = vim.diagnostic.severity.WARN }
      ),
    }

    return opts
  end,
}
