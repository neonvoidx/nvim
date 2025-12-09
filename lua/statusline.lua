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
  local highlight =
    { bg = opts.guibg ~= NONE and opts.guibg or "NONE", fg = opts.guifg ~= NONE and opts.guifg or "NONE" }
  if opts.gui == "bold" then
    highlight.bold = true
  elseif opts.gui == "italic" then
    highlight.italic = true
  end
  vim.api.nvim_set_hl(0, group, highlight)
end

local mode_specs = {}

local function define_mode_spec(modes, name, color)
  for _, mode in ipairs(modes) do
    mode_specs[mode] = { name = name, color = color }
  end
end

define_mode_spec({ "n", "no", "nov", "noV", "no\22", "niI", "niR", "niV", "nt" }, "NORMAL", palette.green)
define_mode_spec({ "v", "vs" }, "VISUAL", palette.purple)
define_mode_spec({ "V", "Vs" }, "V-LINE", palette.purple)
define_mode_spec({ "\22", "\22s" }, "V-BLOCK", palette.purple)
define_mode_spec({ "s" }, "SELECT", palette.yellow)
define_mode_spec({ "S" }, "S-LINE", palette.yellow)
define_mode_spec({ "\19" }, "S-BLOCK", palette.yellow)
define_mode_spec({ "i", "ic", "ix" }, "INSERT", palette.cyan)
define_mode_spec({ "R", "Rc", "Rx" }, "REPLACE", palette.red)
define_mode_spec({ "Rv", "Rvc", "Rvx" }, "V-REPLACE", palette.red)
define_mode_spec({ "c", "cr", "cv", "cvr" }, "COMMAND", palette.yellow)
define_mode_spec({ "r" }, "PROMPT", palette.red)
define_mode_spec({ "rm" }, "MORE", palette.red)
define_mode_spec({ "r?" }, "CONFIRM", palette.red)
define_mode_spec({ "!" }, "SHELL", palette.pink)
define_mode_spec({ "t" }, "TERMINAL", palette.pink)

local status_highlights = {
  StatusLine = { guibg = palette.bg_highlight, guifg = palette.fg },
  StatusLineNC = { guibg = palette.bg_dark, guifg = palette.muted },
  StatusGit = { guibg = palette.bg_highlight, guifg = palette.pink, gui = "bold" },
  StatusDiffAdd = { guibg = palette.bg_highlight, guifg = palette.green, gui = "bold" },
  StatusDiffChange = { guibg = palette.bg_highlight, guifg = palette.yellow, gui = "bold" },
  StatusDiffDelete = { guibg = palette.bg_highlight, guifg = palette.red, gui = "bold" },
  StatusCenter = { guibg = palette.bg_highlight, guifg = palette.fg, gui = "bold" },
  StatusFiletype = { guibg = palette.bg_highlight, guifg = palette.purple, gui = "bold" },
  StatusLocation = { guibg = palette.bg_highlight, guifg = palette.green, gui = "bold" },
  StatusLSP = { guibg = palette.bg_highlight, guifg = palette.cyan, gui = "bold" },
  StatusMeta = { guibg = palette.bg_highlight, guifg = palette.muted },
  StatusErrorIcon = { guibg = palette.bg_highlight, guifg = palette.red, gui = "bold" },
  StatusWarnIcon = { guibg = palette.bg_highlight, guifg = palette.yellow, gui = "bold" },
  StatusInfoIcon = { guibg = palette.bg_highlight, guifg = palette.cyan, gui = "bold" },
  StatusHintIcon = { guibg = palette.bg_highlight, guifg = palette.muted },
}

local function get_mode_spec()
  return mode_specs[fn.mode(1)]
end

local function get_mode_name()
  local spec = get_mode_spec()
  return spec and spec.name or fn.mode()
end

local function set_mode_highlight()
  local spec = get_mode_spec()
  local color = spec and spec.color or palette.green
  hi("StatusModeLabel", { guibg = color, guifg = palette.bg_dark, gui = "bold" })
end

local function apply_highlights()
  for group, opts in pairs(status_highlights) do
    hi(group, opts)
  end
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
  local segments = {
    { value = added, prefix = "%#StatusDiffAdd#+" },
    { value = changed, prefix = "%#StatusDiffChange#~" },
    { value = removed, prefix = "%#StatusDiffDelete#-" },
  }
  for _, segment in ipairs(segments) do
    if segment.value > 0 then
      parts[#parts + 1] = segment.prefix .. segment.value
    end
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
  local severity = vim.diagnostic.severity
  local counts = {
    error = #vim.diagnostic.get(0, { severity = severity.ERROR }),
    warn = #vim.diagnostic.get(0, { severity = severity.WARN }),
    info = #vim.diagnostic.get(0, { severity = severity.INFO }),
    hint = #vim.diagnostic.get(0, { severity = severity.HINT }),
  }
  local parts = {}
  local diagnostic_segments = {
    { value = counts.error, prefix = "%#StatusErrorIcon#E" },
    { value = counts.warn, prefix = "%#StatusWarnIcon#W" },
    { value = counts.info, prefix = "%#StatusInfoIcon#I" },
    { value = counts.hint, prefix = "%#StatusHintIcon#H" },
  }
  for _, segment in ipairs(diagnostic_segments) do
    if segment.value > 0 then
      parts[#parts + 1] = segment.prefix .. segment.value
    end
  end
  if #parts == 0 then
    return ""
  end
  return table.concat(parts, "%#StatusMeta# ") .. "%*"
end

local function get_git_blame()
  local blame = vim.b.gitsigns_blame_line
  if not blame or blame == "" then
    return ""
  end
  return blame
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

local function get_filename()
  local filename = fn.expand("%:t")
  if filename == "" then
    filename = "[No Name]"
  end
  if vim.bo.modified then
    filename = filename .. " [+]"
  end
  return filename
end

local function build_left_section()
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
    local blame = get_git_blame()
    if blame ~= "" then
      left[#left + 1] = " %#StatusMeta#"
      left[#left + 1] = blame
      left[#left + 1] = "%*"
    end
  end
  return table.concat(left)
end

local function build_right_section()
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
  local filename = get_filename()
  local right = {}
  right[#right + 1] =
    table.concat({ " %#StatusCenter#", filename, " %*", "%#StatusFiletype# ", get_file_icon(), filetype })
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
  local progress = (vim.ui and vim.ui.progress_status and vim.ui.progress_status()) or ""
  if progress ~= "" then
    right[#right + 1] = " %#StatusMeta#"
    right[#right + 1] = progress
    right[#right + 1] = "%*"
  end
  right[#right + 1] = " %#StatusLocation# %l:%c %*"
  return table.concat(right)
end

local function build()
  return table.concat({ build_left_section(), "%=", build_right_section(), "%<" })
end

vim.opt.laststatus = 3
vim.opt.showmode = false
_G.custom_statusline_build = build
vim.o.statusline = "%!v:lua.custom_statusline_build()"
local statusline_update = vim.api.nvim_create_augroup("StatuslineUpdate", { clear = true })
vim.api.nvim_create_autocmd("CursorMoved", {
  group = statusline_update,
  callback = function()
    pcall(vim.cmd, "redrawstatus")
  end,
})
vim.api.nvim_create_autocmd("CursorHold", {
  group = statusline_update,
  callback = function()
    pcall(vim.cmd, "redrawstatus")
  end,
})
vim.api.nvim_create_autocmd({ "CursorMovedI", "BufWritePost", "TextChanged", "TextChangedI" }, {
  group = statusline_update,
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("StatuslineColors", { clear = true }),
  callback = apply_highlights,
})

apply_highlights()
