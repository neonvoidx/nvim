vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.skip_ts_context_commentstring_module = true

local opt = vim.opt
opt.autowrite = true
opt.autoread = true
opt.clipboard = "unnamedplus"
opt.complete = ".,w,b,o"
opt.completeopt = "menu,noselect,fuzzy,popup"
opt.winborder = "rounded"
opt.autocomplete = true
opt.autocompletedelay = 250
opt.cmdheight = 0
opt.conceallevel = 1
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.list = false
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.mouse = "nv"
opt.mousemoveevent = true
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.pumborder = "rounded"
opt.relativenumber = true
opt.scrolloff = 4
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes:2"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.softtabstop = 2
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
do
  local cwd = vim.fn.getcwd()
  local git_dir = vim.fs.find(".git", { path = cwd, upward = true })[1]
  local root = git_dir and vim.fn.fnamemodify(git_dir, ":h") or cwd
  local shada_dir = vim.fn.stdpath("state") .. "/shada-projects"

  vim.fn.mkdir(shada_dir, "p")
  opt.shadafile = shada_dir .. "/" .. vim.fn.sha256(root) .. ".shada"
end
opt.foldcolumn = "0"
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "?",
    },
  },
})
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.sessionoptions = { "blank", "buffers", "curdir", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ a = true, A = true, W = true, c = true, C = true })
opt.spelllang = { "en" }
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
