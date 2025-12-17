return {
  "esmuellert/vscode-diff.nvim",
  branch = "next",
  cmd = { "CodeDiff" },
  config = function()
    require("vscode-diff").setup({
      -- your config...
    })
  end,
}
