return {
  "andymass/vim-matchup",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    treesitter = {
      stopline = 500,
    },
  },
  config = function(_, opts)
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    if opts.treesitter then
      require("nvim-treesitter-textobjects") -- ensure loaded
    end
  end,
}
