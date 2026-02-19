return {
  url = "https://codeberg.org/andyg/leap.nvim",
  event = "VeryLazy",
  dependencies = {
    { "tpope/vim-repeat", event = "VeryLazy" },
  },
  config = function(_)
    -- 1-character search (enhanced f/t motions)
    do
      local function as_ft(key_specific_args)
        local common_args = {
          inputlen = 1,
          inclusive = true,
          opts = {
            labels = "",
            safe_labels = vim.fn.mode(1):match("o") and "" or nil,
            case_sensitive = true,
          },
        }
        return vim.tbl_deep_extend("keep", common_args, key_specific_args)
      end

      local clever = require("leap.user").with_traversal_keys
      local clever_f = clever("f", "F")
      local clever_t = clever("t", "T")

      for key, args in pairs({
        f = { opts = clever_f },
        F = { backward = true, opts = clever_f },
        t = { offset = -1, opts = clever_t },
        T = { backward = true, offset = 1, opts = clever_t },
      }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("leap").leap(as_ft(args))
        end)
      end
    end
  end,
}
