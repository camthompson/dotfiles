local util = require("core.util")

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function(_, opts)
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      -- Trouble integration
      if pcall(require, "trouble") then
        config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
      end

      -- Image previewer
      local img_previewer
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
          ["--layout"] = "reverse",
        },
        defaults = {
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        ui_select = function(fzf_opts, items)
          return vim.tbl_deep_extend("force", fzf_opts, {
            prompt = " ",
            winopts = {
              title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
              title_pos = "center",
            },
          }, fzf_opts.kind == "codeaction" and {
            winopts = {
              layout = "vertical",
              height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 4) + 0.5) + 16,
              width = 0.5,
              preview = not vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
                layout = "vertical",
                vertical = "down:15,border-top",
                hidden = "hidden",
              } or {
                layout = "vertical",
                vertical = "down:15,border-top",
              },
            },
          } or {
            winopts = {
              width = 0.5,
              height = math.floor(math.min(vim.o.lines * 0.8, #items + 4) + 0.5),
            },
          })
        end,
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
            layout = "vertical",
            vertical = "down:60%",
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      }
    end,
    config = function(_, opts)
      if opts[1] == "default-title" then
        local function fix(t)
          t.prompt = t.prompt ~= nil and " " or nil
          for _, v in pairs(t) do
            if type(v) == "table" then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
        opts[1] = nil
      end
      require("fzf-lua").setup(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          vim.ui.select = function(...)
            require("lazy").load({ plugins = { "fzf-lua" } })
            local fzf_opts = require("lazy.core.config").plugins["fzf-lua"]
            local ui_select = fzf_opts and fzf_opts.opts and type(fzf_opts.opts) == "table" and fzf_opts.opts.ui_select
            require("fzf-lua").register_ui_select(ui_select or nil)
            return vim.ui.select(...)
          end
        end,
      })
    end,
    keys = {
      { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
      { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
      -- User overrides
      { "<leader><leader>", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fa", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
      { ",,", function() require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() }) end, desc = "Recent (cwd)" },
      { "<leader>;", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      -- Standard fzf keymaps
      { "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      -- find
      { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>fB", "<cmd>FzfLua buffers<cr>", desc = "Buffers (all)" },
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (Root Dir)" },
      { "<leader>fF", function() require("fzf-lua").files({ cwd = vim.uv.cwd() }) end, desc = "Find Files (cwd)" },
      { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", function() require("fzf-lua").oldfiles({ cwd = vim.uv.cwd() }) end, desc = "Recent (cwd)" },
      -- git
      { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
      { "<leader>gd", "<cmd>FzfLua git_diff<cr>", desc = "Git Diff (hunks)" },
      { "<leader>gs", "<cmd>FzfLua git_status<CR>", desc = "Status" },
      { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },
      -- search
      { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
      { "<leader>s/", "<cmd>FzfLua search_history<cr>", desc = "Search History" },
      { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>FzfLua lines<cr>", desc = "Buffer Lines" },
      { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
      { "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", desc = "Buffer Diagnostics" },
      { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>sG", function() require("fzf-lua").live_grep({ cwd = vim.uv.cwd() }) end, desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
      { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
      { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
      { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
      { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
      { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (Root Dir)" },
      { "<leader>sW", function() require("fzf-lua").grep_cword({ cwd = vim.uv.cwd() }) end, desc = "Word (cwd)" },
      { "<leader>sw", "<cmd>FzfLua grep_visual<cr>", mode = "x", desc = "Selection (Root Dir)" },
      { "<leader>sW", function() require("fzf-lua").grep_visual({ cwd = vim.uv.cwd() }) end, mode = "x", desc = "Selection (cwd)" },
      { "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
      {
        "<leader>ss",
        function()
          require("fzf-lua").lsp_document_symbols()
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols()
        end,
        desc = "Goto Symbol (Workspace)",
      },
    },
  },

  -- Todo fzf integration
  {
    "folke/todo-comments.nvim",
    optional = true,
    keys = {
      { "<leader>st", function() require("todo-comments.fzf").todo() end, desc = "Todo" },
      { "<leader>sT", function() require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
}
