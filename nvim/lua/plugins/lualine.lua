return {
  event = "VeryLazy",
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.remove(opts.sections.lualine_z)
  end,
}
