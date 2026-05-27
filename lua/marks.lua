local M = {}

local ns = vim.api.nvim_create_namespace("visible-marks")
local mark_group = vim.api.nvim_create_augroup("VisibleMarks", { clear = true })
local local_mark_pattern = "^'[a-z]$"
local global_mark_pattern = "^'[A-Z]$"

local function mark_text(mark)
  return mark:sub(2, 2)
end

local function add_mark(lines, mark)
  local pos = mark.pos
  if not pos or pos[2] <= 0 then
    return
  end

  local line = pos[2]
  lines[line] = lines[line] or {}
  table.insert(lines[line], mark_text(mark.mark))
end

local function sorted_mark_text(marks)
  table.sort(marks)
  return table.concat(marks):sub(1, 2)
end

function M.refresh(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local lines = {}

  for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
    if mark.mark:match(local_mark_pattern) then
      add_mark(lines, mark)
    end
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)
  for _, mark in ipairs(vim.fn.getmarklist()) do
    if mark.mark:match(global_mark_pattern) and mark.file ~= "" and vim.fn.fnamemodify(mark.file, ":p") == bufname then
      add_mark(lines, mark)
    end
  end

  for line, marks in pairs(lines) do
    if line <= line_count then
      vim.api.nvim_buf_set_extmark(bufnr, ns, line - 1, 0, {
        priority = 20,
        sign_hl_group = "Identifier",
        sign_text = sorted_mark_text(marks),
      })
    end
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "CursorMoved", "TextChanged", "TextChangedI" }, {
    group = mark_group,
    desc = "Show letter marks in the sign column",
    callback = function(args)
      M.refresh(args.buf)
    end,
  })

  vim.keymap.set("n", "m", function()
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or char == "" then
      return
    end

    vim.cmd.normal({ "m" .. char, bang = true })
    vim.schedule(function()
      M.refresh()
    end)
  end, { desc = "Set mark and refresh sign column" })
end

return M
