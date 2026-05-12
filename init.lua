-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.skip_ts_context_commentstring_module = true

require("options")
require("keymaps")
require("autocommands")
require("plugins")
