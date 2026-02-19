local M = {}

--- Get the root directory of the current project.
--- Tries LSP workspace folders first, then falls back to .git detection, then cwd.
function M.root()
  return vim.fs.root(0, { ".git", "lua" }) or vim.uv.cwd()
end

--- Get the git root directory.
function M.git_root()
  return vim.fs.root(0, ".git") or vim.uv.cwd()
end

--- Format the current buffer using conform, with LSP fallback.
function M.format(opts)
  opts = opts or {}
  require("conform").format(vim.tbl_deep_extend("force", {
    bufnr = 0,
    timeout_ms = 3000,
    lsp_format = "fallback",
  }, opts))
end

--- Copilot LSP status, keyed by client_id.
--- Populated by the didChangeStatus handler in copilot.lua.
---@type table<number, "ok"|"error"|"pending">
M.copilot_status = {}

return M
