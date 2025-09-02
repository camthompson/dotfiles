return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "top",
      },
    },
  },
  keys = {
    { ",,", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
  },
}
