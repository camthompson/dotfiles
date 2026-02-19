return {
  "kokusenz/deltaview.nvim",
  cmd = { "DeltaView", "DeltaMenu", "Delta" },
  keys = {
    { "<leader>gv", "<cmd>DeltaView<cr>", desc = "DeltaView (file)" },
    { "<leader>gV", "<cmd>DeltaMenu<cr>", desc = "DeltaMenu (selector)" },
    { "<leader>g.", "<cmd>Delta<cr>", desc = "Delta (path)" },
  },
}
