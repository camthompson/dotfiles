return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ibhagwan/fzf-lua",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = "Octo",
  keys = {
    { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs (Octo)" },
    { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List issues (Octo)" },
    { "<leader>gor", "<cmd>Octo review start<cr>", desc = "Start review (Octo)" },
    { "<leader>goe", "<cmd>Octo review resume<cr>", desc = "Edit review (Octo)" },
    { "<leader>gos", "<cmd>Octo review submit<cr>", desc = "Submit review (Octo)" },
  },
  opts = {
    picker = "fzf-lua",
    suppress_missing_scope = {
      projects_v2 = true,
    },
  },
}
