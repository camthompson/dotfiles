return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "ibhagwan/fzf-lua",
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gG", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
  opts = {
    integrations = {
      diffview = true,
      fzf_lua = true,
    },
  },
}
