return {
  event = "VeryLazy",
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.remove(opts.sections.lualine_z)

    opts.options = opts.options or {}
    opts.options.section_separators = { left = "", right = "" }
    opts.options.component_separators = { left = ":", right = ":" }
  end,
}
