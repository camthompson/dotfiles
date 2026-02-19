return {
  "nvim-mini/mini.files",
  keys = {
    { "<leader>fm", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end, desc = "Open mini.files (Directory of Current File)" },
    { "<leader>fM", function() require("mini.files").open(vim.uv.cwd(), true) end, desc = "Open mini.files (cwd)" },
  },
  opts = {
    windows = {
      preview = true,
      width_focus = 30,
      width_preview = 30,
    },
    options = {
      use_as_default_explorer = false,
    },
  },
}
