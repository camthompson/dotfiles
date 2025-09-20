return {
  "b0o/incline.nvim",
  config = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    require("incline").setup({
      highlight = {
        groups = {
          InclineNormal = {
            guibg = mocha.mauve,
            guifg = mocha.base,
          },
          InclineNormalNC = {
            guibg = mocha.surface0,
            guifg = mocha.overlay0,
          },
        },
      },
    })
  end,
  event = "VeryLazy",
  dependencies = { "catppuccin/nvim" },
}
