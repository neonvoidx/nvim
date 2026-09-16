-- Global options (ported from ~/nvim, trimmed for nvim-min)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true
opt.autoread = true
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "preselect" }
opt.conceallevel = 1
opt.confirm = true
opt.cmdheight = 0
opt.cursorline = true
opt.expandtab = true
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.list = false
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
opt.softtabstop = 2
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
opt.smoothscroll = true
opt.shada = "!,'300,<50,s10,h"

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.foldmethod = "expr" -- nvim-ufo sets foldexpr in its setup

-- Native builtin (0.13) autocompletion
vim.o.autocomplete = true

-- winborder is an -o (global) option, not exposed by vim.opt
vim.o.winborder = "rounded"

opt.sessionoptions = { "blank", "buffers", "curdir", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ a = true, A = true, W = true, I = true, c = true, C = true })
opt.spelllang = { "en" }

-- Per-project shada (source: ~/nvim)
do
  local cwd = vim.fn.getcwd()
  local git_dir = vim.fs.find(".git", { path = cwd, upward = true })[1]
  local root = git_dir and vim.fn.fnamemodify(git_dir, ":h") or cwd
  local shada_dir = vim.fn.stdpath("state") .. "/shada-projects"

  vim.fn.mkdir(shada_dir, "p")
  vim.opt.shadafile = shada_dir .. "/" .. vim.fn.sha256(root) .. ".shada"
end

opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✖",
      [vim.diagnostic.severity.WARN] = "⬤",
      [vim.diagnostic.severity.INFO] = "…",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  float = {
    border = "rounded",
    format = function(d)
      return ("%s (%s) [%s]"):format(d.message, d.source, d.code or (d.user_data.lsp and d.user_data.lsp.code) or "")
    end,
  },
  underline = true,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
    end,
  },
})