local M = {}

function M.project_root()
  local cwd = vim.fn.getcwd()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local start = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or cwd
  local git_dir = vim.fs.find(".git", { path = start, upward = true })[1]

  if git_dir then
    return vim.fn.fnamemodify(git_dir, ":h")
  end

  return cwd
end

return M
