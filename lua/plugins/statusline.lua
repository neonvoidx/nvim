local M = {}

local NONE = "NONE"

local palette = {
  bg = "#212337",
  bg_dark = "#1b1e2b",
  bg_highlight = "#2d3047",
  fg = "#ebfafa",
  muted = "#7081d0",
  purple = "#c792ea",
  cyan = "#04d1f9",
  green = "#37f499",
  yellow = "#f1fc79",
  red = "#f16c75",
  pink = "#f265b5",
}

local fn = vim.fn

local function hi(group, opts)
  local highlight = {
    bg = opts.guibg ~= NONE and opts.guibg or "NONE",
    fg = opts.guifg ~= NONE and opts.guifg or "NONE",
  }

  if opts.gui == "bold" then
    highlight.bold = true
  elseif opts.gui == "italic" then
    highlight.italic = true
  end

  vim.api.nvim_set_hl(0, group, highlight)
end

hi("StatusLine", { guibg = palette.bg_highlight, guifg = palette.fg })
hi("StatusLineNC", { guibg = palette.bg_dark, guifg = palette.muted })
hi("StatusGit", { guibg = palette.bg_highlight, guifg = palette.pink, gui = "bold" })
hi("StatusDiffAdd", { guibg = palette.bg_highlight, guifg = palette.green, gui = "bold" })
hi("StatusDiffChange", { guibg = palette.bg_highlight, guifg = palette.yellow, gui = "bold" })
hi("StatusDiffDelete", { guibg = palette.bg_highlight, guifg = palette.red, gui = "bold" })
hi("StatusCenter", { guibg = palette.bg_highlight, guifg = palette.fg, gui = "bold" })
hi("StatusFiletype", { guibg = palette.bg_highlight, guifg = palette.purple, gui = "bold" })
hi("StatusLocation", { guibg = palette.bg_highlight, guifg = palette.green, gui = "bold" })
hi("StatusLSP", { guibg = palette.bg_highlight, guifg = palette.cyan, gui = "bold" })
hi("StatusMeta", { guibg = palette.bg_highlight, guifg = palette.muted })
hi("StatusErrorIcon", { guibg = palette.bg_highlight, guifg = palette.red, gui = "bold" })
hi("StatusWarnIcon", { guibg = palette.bg_highlight, guifg = palette.yellow, gui = "bold" })
hi("StatusInfoIcon", { guibg = palette.bg_highlight, guifg = palette.cyan, gui = "bold" })
hi("StatusHintIcon", { guibg = palette.bg_highlight, guifg = palette.muted })

local mode_names = {
  n = "NORMAL",
  no = "NORMAL",
  nov = "NORMAL",
  noV = "NORMAL",
  ["no\22"] = "NORMAL",
  niI = "NORMAL",
  niR = "NORMAL",
  niV = "NORMAL",
  nt = "NORMAL",
  v = "VISUAL",
  vs = "VISUAL",
  V = "V-LINE",
  Vs = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  i = "INSERT",
  ic = "INSERT",
  ix = "INSERT",
  R = "REPLACE",
  Rc = "REPLACE",
  Rx = "REPLACE",
  Rv = "V-REPLACE",
  Rvc = "V-REPLACE",
  Rvx = "V-REPLACE",
  c = "COMMAND",
  cr = "COMMAND",
  cv = "COMMAND",
  cvr = "COMMAND",
  r = "PROMPT",
  rm = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local mode_colors = {
  n = palette.green,
  no = palette.green,
  nov = palette.green,
  noV = palette.green,
  ["no\22"] = palette.green,
  niI = palette.green,
  niR = palette.green,
  niV = palette.green,
  nt = palette.green,
  v = palette.purple,
  vs = palette.purple,
  V = palette.purple,
  Vs = palette.purple,
  ["\22"] = palette.purple,
  ["\22s"] = palette.purple,
  s = palette.yellow,
  S = palette.yellow,
  ["\19"] = palette.yellow,
  i = palette.cyan,
  ic = palette.cyan,
  ix = palette.cyan,
  R = palette.red,
  Rc = palette.red,
  Rx = palette.red,
  Rv = palette.red,
  Rvc = palette.red,
  Rvx = palette.red,
  c = palette.yellow,
  cr = palette.yellow,
  cv = palette.yellow,
  cvr = palette.yellow,
  r = palette.red,
  rm = palette.red,
  ["r?"] = palette.red,
  ["!"] = palette.pink,
  t = palette.pink,
}

local function get_mode_name()
  return mode_names[fn.mode(1)] or fn.mode()
end

local function set_mode_highlight()
  local color = mode_colors[fn.mode(1)] or palette.green
  hi("StatusModeLabel", { guibg = color, guifg = palette.bg_dark, gui = "bold" })
end

local function apply_highlights()
  hi("StatusLine", { guibg = palette.bg_highlight, guifg = palette.fg })
  hi("StatusLineNC", { guibg = palette.bg_dark, guifg = palette.muted })
  hi("StatusGit", { guibg = palette.bg_highlight, guifg = palette.pink, gui = "bold" })
  hi("StatusDiffAdd", { guibg = palette.bg_highlight, guifg = palette.green, gui = "bold" })
  hi("StatusDiffChange", { guibg = palette.bg_highlight, guifg = palette.yellow, gui = "bold" })
  hi("StatusDiffDelete", { guibg = palette.bg_highlight, guifg = palette.red, gui = "bold" })
  hi("StatusCenter", { guibg = palette.bg_highlight, guifg = palette.fg, gui = "bold" })
  hi("StatusFiletype", { guibg = palette.bg_highlight, guifg = palette.purple, gui = "bold" })
  hi("StatusLocation", { guibg = palette.bg_highlight, guifg = palette.green, gui = "bold" })
  hi("StatusLSP", { guibg = palette.bg_highlight, guifg = palette.cyan, gui = "bold" })
  hi("StatusMeta", { guibg = palette.bg_highlight, guifg = palette.muted })
  hi("StatusErrorIcon", { guibg = palette.bg_highlight, guifg = palette.red, gui = "bold" })
  hi("StatusWarnIcon", { guibg = palette.bg_highlight, guifg = palette.yellow, gui = "bold" })
  hi("StatusInfoIcon", { guibg = palette.bg_highlight, guifg = palette.cyan, gui = "bold" })
  hi("StatusHintIcon", { guibg = palette.bg_highlight, guifg = palette.muted })
  set_mode_highlight()
end

local function get_git_branch()
  local branch = vim.b.gitsigns_head
  if not branch or branch == "" then
    return ""
  end

  local gs = vim.b.gitsigns_status_dict
  if gs and gs.root then
    return vim.fn.fnamemodify(gs.root, ":t") .. "/" .. branch
  end

  return branch
end

local function build_git_diff()
  local gs = vim.b.gitsigns_status_dict or {}
  local added = gs.added or gs.add or gs.staged_add or 0
  local changed = gs.changed or gs.change or gs.modified or 0
  local removed = gs.removed or gs.delete or gs.staged_delete or 0
  local parts = {}

  if added > 0 then
    parts[#parts + 1] = "%#StatusDiffAdd#+" .. added
  end
  if changed > 0 then
    parts[#parts + 1] = "%#StatusDiffChange#~" .. changed
  end
  if removed > 0 then
    parts[#parts + 1] = "%#StatusDiffDelete#-" .. removed
  end

  if #parts == 0 then
    return ""
  end

  return table.concat(parts, "%#StatusMeta# ") .. "%*"
end

local function get_diagnostics()
  if not vim.diagnostic then
    return ""
  end

  local counts = {
    error = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
    warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
    info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }),
    hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }),
  }

  local parts = {}
  if counts.error > 0 then
    parts[#parts + 1] = "%#StatusErrorIcon#E" .. counts.error
  end
  if counts.warn > 0 then
    parts[#parts + 1] = "%#StatusWarnIcon#W" .. counts.warn
  end
  if counts.info > 0 then
    parts[#parts + 1] = "%#StatusInfoIcon#I" .. counts.info
  end
  if counts.hint > 0 then
    parts[#parts + 1] = "%#StatusHintIcon#H" .. counts.hint
  end

  if #parts == 0 then
    return ""
  end

  return table.concat(parts, "%#StatusMeta# ") .. "%*"
end

local function get_lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end

  table.sort(names)
  return table.concat(names, ",")
end

local function get_file_icon()
  local ok, icons = pcall(require, "nvim-web-devicons")
  if not ok then
    return ""
  end

  local filename = fn.expand("%:t")
  local extension = fn.expand("%:e")
  local icon = icons.get_icon(filename, extension, { default = true })
  return icon and icon .. " " or ""
end

function M.build()
  set_mode_highlight()

  local left = { "%#StatusModeLabel# ", get_mode_name(), " %*" }

  local branch = get_git_branch()
  if branch ~= "" then
    left[#left + 1] = " %#StatusGit# "
    left[#left + 1] = branch
    left[#left + 1] = " %*"

    local diff = build_git_diff()
    if diff ~= "" then
      left[#left + 1] = " "
      left[#left + 1] = diff
    end
  end

  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
  local filename = fn.expand("%:t")
  if filename == "" then
    filename = "[No Name]"
  end
  if vim.bo.modified then
    filename = filename .. " [+]"
  end

  local right = {}
  right[#right + 1] = table.concat({
    " %#StatusCenter#",
    filename,
    " %*",
    "%#StatusFiletype# ",
    get_file_icon(),
    filetype,
  })

  local lsp_clients = get_lsp_clients()
  if lsp_clients ~= "" then
    right[#right + 1] = " %#StatusLSP#󰒋 "
    right[#right + 1] = lsp_clients
    right[#right + 1] = " %*"
  end

  local diagnostics = get_diagnostics()
  if diagnostics ~= "" then
    right[#right + 1] = " "
    right[#right + 1] = diagnostics
  end

  local progress = vim.ui.progress_status()
  if progress ~= "" then
    right[#right + 1] = " %#StatusMeta#"
    right[#right + 1] = progress
    right[#right + 1] = "%*"
  end

  right[#right + 1] = " %#StatusLocation# %l:%c %*"

  return table.concat({ table.concat(left), "%=", table.concat(right), "%<" })
end

vim.opt.laststatus = 3
vim.opt.showmode = false
vim.o.statusline = "%!v:lua.require('plugins.statusline').build()"

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("StatuslineColors", { clear = true }),
  callback = apply_highlights,
})

apply_highlights()

return M
