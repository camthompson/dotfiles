return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader><leader>", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
    { "<leader>fa", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    { ",,", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
    { "<leader>;", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
  },
}
