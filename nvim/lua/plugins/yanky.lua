return {
  "gbprod/yanky.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    highlight = { timer = 150 },
  },
  keys = {
    { "<leader>p", function() require("yanky").yank_history() end, mode = { "n", "x" }, desc = "Open Yank History" },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
    -- p/P/gp/gP/<c-p>/<c-n> are set in core/keymaps.lua
    { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
    { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
  },
}
