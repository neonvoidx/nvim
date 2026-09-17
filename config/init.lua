-- nvim-min: minimal Neovim 0.13 config.
-- Plugin management: vim.pack (builtin). Everything else is Nix-delivered.
vim.cmd([[set expandtab tabstop=2 shiftwidth=2 softtabstop=2]])

require("pack")

require("options")
require("keymaps")
require("autocmds")
require("lsp")

require("plugins")

require("statusline").setup()

vim.cmd.colorscheme("eldritch")
