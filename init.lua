-- Globals
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.disable_autoformat = false
vim.g.skip_ts_context_commentstring_module = true
vim.g.markdown_recommended_style = 0
vim.g.qf_is_open = false

require("options")
require("keymaps")
require("autocommands")
require("plugins")
-- require("statusline")
