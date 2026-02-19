local icons = require("core.icons")
local util = require("core.util")

--- Simplified pretty_path component adapted from LazyVim.
--- Truncates to `length` segments, bolds filename, highlights modified/readonly.
local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  local function hl(component, text, hl_group)
    if not hl_group or hl_group == "" then
      return text
    end
    component.hl_cache = component.hl_cache or {}
    local lualine_hl = component.hl_cache[hl_group]
    if not lualine_hl then
      local utils = require("lualine.utils.utils")
      local gui = vim.tbl_filter(function(x) return x end, {
        utils.extract_highlight_colors(hl_group, "bold") and "bold",
        utils.extract_highlight_colors(hl_group, "italic") and "italic",
      })
      lualine_hl = component:create_hl({
        fg = utils.extract_highlight_colors(hl_group, "fg"),
        gui = #gui > 0 and table.concat(gui, ",") or nil,
      }, "PP_" .. hl_group)
      component.hl_cache[hl_group] = lualine_hl
    end
    return component:format_hl(lualine_hl) .. text:gsub("%%", "%%%%") .. component:get_default_hl()
  end

  return function(self)
    local path = vim.fn.expand("%:p")
    if path == "" then
      return ""
    end

    local cwd = vim.uv.cwd() or ""
    if cwd ~= "" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    end

    local sep = "/"
    local parts = vim.split(path, sep)

    if opts.length > 0 and #parts > opts.length then
      parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts) }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = hl(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = hl(self, parts[#parts], opts.filename_hl)
    end

    local dir = ""
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = hl(self, dir .. sep, opts.directory_hl)
    end

    local readonly = ""
    if vim.bo.readonly then
      readonly = hl(self, opts.readonly_icon, opts.modified_hl)
    end
    return dir .. parts[#parts] .. readonly
  end
end

--- Root dir component — shows project root basename when it differs from cwd.
local function root_dir()
  local function get()
    local cwd = vim.uv.cwd() or ""
    local root = util.root()
    if root == cwd then
      return nil
    end
    return vim.fs.basename(root)
  end

  return {
    function()
      return "󱉭 " .. get()
    end,
    cond = function()
      return get() ~= nil
    end,
    color = function()
      return { fg = Snacks.util.color("Special") }
    end,
  }
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local lualine_require = require("lualine_require")
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    local opts = {
      options = {
        theme = "auto",
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        section_separators = { left = "", right = "" },
        component_separators = { left = ":", right = ":" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          root_dir(),
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { pretty_path() },
        },
        lualine_x = {
          -- Copilot status
          {
            function()
              return " "
            end,
            cond = function()
              local status = require("core.util").copilot_status
              local clients = vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
              return #clients > 0 and status[clients[1].id] ~= nil
            end,
            color = function()
              local colors = { ok = "Special", error = "DiagnosticError", pending = "DiagnosticWarn" }
              local status = require("core.util").copilot_status
              local clients = vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
              local s = #clients > 0 and status[clients[1].id] or "ok"
              return { fg = Snacks.util.color(colors[s] or colors.ok) }
            end,
          },
          Snacks.profiler.status(),
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = function() return { fg = Snacks.util.color("Statement") } end,
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = function() return { fg = Snacks.util.color("Constant") } end,
          },
          -- stylua: ignore
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = function() return { fg = Snacks.util.color("Special") } end,
          },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {},
      },
      extensions = { "neo-tree", "lazy", "fzf" },
    }

    -- Add trouble symbols if available
    if vim.g.trouble_lualine ~= false and pcall(require, "trouble") then
      local trouble = require("trouble")
      local symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "lualine_c_normal",
      })
      table.insert(opts.sections.lualine_c, {
        symbols and symbols.get,
        cond = function()
          return vim.b.trouble_lualine ~= false and symbols.has()
        end,
      })
    end

    return opts
  end,
}
