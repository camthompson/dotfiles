return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><leader>", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fa", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    { ",,", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
    { "<leader>;", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
  },
}
