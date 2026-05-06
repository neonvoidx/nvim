-- #region GLOBALS
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.skip_ts_context_commentstring_module = true
vim.g.markdown_recommended_style = 0
vim.g.qf_is_open = false
-- #endregion

-- #region PLUGINS
vim.pack.add({
  { src = "https://github.com/eldritch-theme/eldritch.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/Bekaboo/dropbar.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/folke/noice.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/rcarriga/nvim-notify" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/numToStr/Comment.nvim" },
})
-- #endregion

-- #region OPTIONS
local opt = vim.opt
opt.autowrite = true
opt.autoread = true
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 1
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.list = true
opt.mouse = "nv"
opt.mousemoveevent = true
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 4
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
opt.autochdir = false
opt.smoothscroll = true
opt.shada = "!,'300,<50,s10,h"
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.spelllang = { "en" }
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.o.winborder = "rounded"
-- #endregion

-- #region DIAGNOSTICS
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋼",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  float = {
    border = "rounded",
    format = function(d)
      local code = d.code or (d.user_data and d.user_data.lsp and d.user_data.lsp.code) or ""
      return ("%s (%s) [%s]"):format(d.message, d.source or "lsp", code)
    end,
  },
  underline = true,
  jump = { float = true },
})
-- #endregion

-- #region HELPERS
local map = vim.keymap.set

local function get_visual()
  local _, ls, cs = table.unpack(vim.fn.getpos("v"))
  local _, le, ce = table.unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

local function compare_to_clip()
  local ftype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.cmd("normal! P")
  vim.opt_local.buftype = "nowrite"
  vim.opt_local.filetype = ftype
  vim.cmd("diffthis")
  vim.cmd([[execute "normal! \<C-w>h"]])
  vim.cmd("diffthis")
end
-- #endregion

-- #region KEYMAPS
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw / clear hlsearch / diff update" })
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w!<cr><esc>", { desc = "Save file" })
map({ "i", "n" }, "<C-q>", "<cmd>silent! xa<cr>", { desc = "Save all and quit" })
map("v", "<", "<gv")
map("v", ">", ">gv")
map("n", "<leader>wd", "<cmd>q<cr>", { desc = "Delete window", remap = true })
map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split right", remap = true })
map("n", "<leader>w-", "<cmd>split<cr>", { desc = "Split below", remap = true })
map("i", "jj", "<Esc>")
map("i", "kk", "<Esc>")
local esc_modes = { "i", "n", "v", "x", "o", "t", "s", "c", "l" }
map(esc_modes, "<Insert>", "<Esc>")
map(esc_modes, "<F1>", "<Nop>")
map(esc_modes, "<C-LeftMouse>", "<Nop>")
map("n", "<C-t>", "<Nop>")
map({ "n", "v" }, "D", '"_d')
map({ "n", "v" }, "C", '"_c')
map("v", "<C-r>", function()
  local pattern = table.concat(get_visual())
  pattern = vim.fn.substitute(vim.fn.escape(pattern, "^$.*\\/~[]"), "\n", "\\n", "g")
  vim.api.nvim_input("<Esc>:%s/" .. pattern .. "//g<Left><Left>")
end)
map("n", "<Backspace>", "^", { desc = "Move to first non-blank character" })
map("v", "p", '"_dP')
map("n", "<leader>D", compare_to_clip, { desc = "Diff vs clipboard" })
-- #endregion

-- #region AUTOCOMMANDS
local function augroup(name)
  return vim.api.nvim_create_augroup("autocmd_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].autocmd_last_loc then
      return
    end
    vim.b[buf].autocmd_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup", "help", "lspinfo", "man", "notify", "qf",
    "query", "spectre_panel", "startuptime", "tsplayground",
    "neotest-output", "checkhealth", "neotest-summary",
    "neotest-output-panel", "lazy",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_ft"),
  pattern = { "gitcommit", "markdown", "snacks_notif_history", "trouble" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("spell_ft"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

local numtog = augroup("NumberToggle")
vim.api.nvim_create_autocmd("InsertEnter", {
  group = numtog,
  pattern = "*",
  callback = function()
    local ignore = { oil = true, fzf = true }
    if ignore[vim.bo.filetype] then
      return
    end
    vim.wo.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = numtog,
  pattern = "*",
  callback = function()
    local ignore = { oil = true, fzf = true }
    if ignore[vim.bo.filetype] then
      return
    end
    vim.wo.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_pairs"),
  pattern = { "gitcommit", "markdown" },
  callback = function(event)
    vim.keymap.set("i", "`", "`", { buffer = event.buf })
    vim.b[event.buf].ai_cmp = false
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("copilot_buf"),
  pattern = "copilot-*",
  callback = function()
    vim.opt_local.relativenumber = false
    vim.opt_local.number = false
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight when yanking (copying) text",
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("RestoreCursor"),
  callback = function(args)
    vim.api.nvim_create_autocmd("FileType", {
      buffer = args.buf,
      once = true,
      callback = function()
        local ft = vim.bo[args.buf].filetype
        local last_pos = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
        local last_line = vim.api.nvim_buf_line_count(args.buf)
        if last_pos >= 1 and last_pos <= last_line and not ft:match("commit") and not vim.tbl_contains({ "gitrebase", "nofile", "svn", "gitcommit" }, ft) then
          vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
        end
      end,
    })
  end,
})
-- #endregion

-- #region UTILITIES
local has = function(bin)
  return vim.fn.executable(bin) == 1
end
-- #endregion

-- #region COLORSCHEME
require("eldritch").setup({ transparent = true })
vim.cmd.colorscheme("eldritch")
-- #endregion

-- #region TREESITTER
pcall(function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "go",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  })
end)

require("treesitter-context").setup({
  enable = true,
  multiwindow = true,
  max_lines = 0,
  separator = "▔",
})
map("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Go to Treesitter context" })
-- #endregion

-- #region LAZYDEV
require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
-- #endregion

-- #region WHICH-KEY
require("which-key").setup({ preset = "helix", delay = 300 })
-- #endregion

-- #region GIT
require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function bmap(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    bmap("n", "]h", gs.next_hunk, "Next hunk")
    bmap("n", "[h", gs.prev_hunk, "Previous hunk")
    bmap("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
    bmap("n", "<leader>ghd", gs.diffthis, "Diff this")
    bmap("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff project")
    bmap("n", "<leader>ghP", gs.preview_hunk, "Preview hunk")
    bmap("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
    bmap("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
    bmap("v", "<leader>ghr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")
    bmap("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
    bmap("v", "<leader>ghs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
    bmap("n", "<leader>gtb", gs.toggle_current_line_blame, "Toggle blame")
    bmap("n", "<leader>gtd", gs.toggle_deleted, "Toggle deleted")
  end,
})

require("diffview").setup({
  enhanced_diff_hl = true,
  use_icons = true,
  view = {
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
    },
  },
})
map("n", "<leader>gd", function()
  local lib = require("diffview.lib")
  if lib.get_current_view() then
    vim.cmd.DiffviewClose()
  else
    vim.cmd.DiffviewOpen()
  end
end, { desc = "Diffview toggle" })
-- #endregion

-- #region TROUBLE
require("trouble").setup({
  modes = {
    diagnostics_buffer = {
      mode = "diagnostics",
      filter = { buf = 0 },
    },
  },
})
map("n", "<leader>xx", "<cmd>Trouble diagnostics_buffer toggle<cr>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
-- #endregion

-- #region OIL
require("oil").setup({
  default_file_explorer = true,
  view_options = { show_hidden = true },
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
  },
})
map("n", "<leader>e", "<cmd>Oil<cr>", { desc = "Open file explorer" })
map("n", "<leader>E", function()
  require("oil").open(vim.fn.getcwd())
end, { desc = "Open explorer at cwd" })
-- #endregion

-- #region UI
require("ibl").setup()
require("Comment").setup()
require("todo-comments").setup()
require("lualine").setup({ options = { theme = "eldritch", globalstatus = true } })
require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
  },
})
require("notify").setup({ background_colour = "#000000", render = "wrapped-compact" })
vim.notify = require("notify")
require("noice").setup({
  lsp = {
    progress = { enabled = true },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    inc_rename = true,
    lsp_doc_border = true,
    long_message_to_split = false,
  },
})

require("dropbar").setup()
-- #endregion

-- #region COMPLETION
local blink = require("blink.cmp")
blink.setup({
  enabled = function()
    return not vim.tbl_contains({ "oil" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.ai_cmp ~= false
  end,
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    sorts = { "exact", "score", "sort_text" },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      window = { border = "rounded" },
    },
    trigger = { prefetch_on_insert = false },
    menu = {
      auto_show = true,
      border = "rounded",
      min_width = 60,
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = true,
      },
    },
  },
  signature = {
    enabled = true,
    window = { border = "rounded" },
  },
  keymap = {
    preset = "none",
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<Tab>"] = { "accept", "fallback" },
    ["<C-l>"] = { "scroll_documentation_up", "fallback" },
    ["<C-h>"] = { "scroll_documentation_down", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "snippet_forward", "fallback" },
    ["<C-Tab>"] = { "snippet_backward", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  cmdline = { enabled = false },
})
-- #endregion

-- #region FORMATTING
require("conform").setup({
  notify_on_error = false,
  formatters = {
    prettierd = { require_cwd = true },
  },
  formatters_by_ft = {
    javascript = { "eslint_d", "prettierd" },
    typescript = { "eslint_d", "prettierd" },
    javascriptreact = { "eslint_d", "prettierd" },
    typescriptreact = { "eslint_d", "prettierd" },
    ["javascript.jsx"] = { "eslint_d", "prettierd" },
    ["typescript.tsx"] = { "eslint_d", "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    lua = { "stylua" },
    python = { "isort", "black" },
    markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
    ["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
    nix = { "nixfmt" },
    rust = { "rustfmt" },
    go = { "gofmt" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

vim.g.disable_autoformat = false
map("n", "<leader>cf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"), vim.log.levels.INFO, { title = "Conform" })
end, { desc = "Toggle autoformat" })
map("n", "<leader>cF", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat
  vim.notify("Autoformat " .. (vim.b[bufnr].disable_autoformat and "disabled" or "enabled") .. " (buffer)", vim.log.levels.INFO, { title = "Conform" })
end, { desc = "Toggle autoformat (buffer)" })
-- #endregion

-- #region LINTING
local lint = require("lint")
if has("eslint_d") then
  vim.env.ESLINT_D_PPID = tostring(vim.fn.getpid())
end
lint.linters_by_ft = {
  cmake = { "cmakelint" },
  javascript = has("eslint_d") and { "eslint_d" } or nil,
  javascriptreact = has("eslint_d") and { "eslint_d" } or nil,
  ["javascript.jsx"] = has("eslint_d") and { "eslint_d" } or nil,
  typescript = has("eslint_d") and { "eslint_d" } or nil,
  typescriptreact = has("eslint_d") and { "eslint_d" } or nil,
  ["typescript.tsx"] = has("eslint_d") and { "eslint_d" } or nil,
  markdown = has("markdownlint-cli2") and { "markdownlint-cli2" } or nil,
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    require("lint").try_lint()
  end,
})
-- #endregion

-- #region LSP
local servers = {
  basedpyright = {},
  clangd = {},
  gopls = {},
  lua_ls = {},
  nixd = {},
  rust_analyzer = {},
  ts_ls = {},
  yamlls = {},
}

if has("vscode-eslint-language-server") then
  servers.eslint = {}
elseif has("eslint-lsp") then
  servers.eslint = { cmd = { "eslint-lsp" } }
end

local capabilities = blink.get_lsp_capabilities()
for server, config in pairs(servers) do
  config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local function lmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    lmap("gd", vim.lsp.buf.definition, "Goto definition")
    lmap("gr", vim.lsp.buf.references, "Goto references")
    lmap("gI", vim.lsp.buf.implementation, "Goto implementation")
    lmap("gy", vim.lsp.buf.type_definition, "Goto type definition")
    lmap("K", vim.lsp.buf.hover, "Hover")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Code action (line)")
    lmap("<leader>cA", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source" }, diagnostics = {} },
      })
    end, "Code action (buffer)")
    lmap("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    lmap("<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
    lmap("<leader>ll", function()
      vim.cmd("edit " .. vim.lsp.get_log_path())
    end, "LSP Logs")
    lmap("<leader>r", "<cmd>LspRestart<cr>", "LSP Restart")
    if vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = ev.buf })
    end
  end,
})
-- #endregion

-- #region EXTRA KEYMAPS
map("n", "<leader><space>", function()
  require("oil").open()
end, { desc = "Smart Find Files" })
map("n", "<leader>/", function()
  vim.ui.input({ prompt = "rg > " }, function(input)
    if input and input ~= "" then
      vim.cmd("silent grep! " .. vim.fn.shellescape(input))
      vim.cmd("copen")
    end
  end)
end, { desc = "Grep" })
map("n", "<leader>gs", "<cmd>tabnew | terminal git status<cr>", { desc = "Git Status", silent = true })
-- #endregion
