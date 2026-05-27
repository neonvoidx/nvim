local project_root = require("util").project_root

vim.pack.add({
  -- Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- UI
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/eldritch-theme/eldritch.nvim",
  "https://github.com/dmtrKovalenko/fff.nvim",
  "https://github.com/mikesmithgh/kitty-scrollback.nvim",
  "https://github.com/folke/persistence.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/knubie/vim-kitty-navigator",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mikavilpas/yazi.nvim",
  -- Coding
  "https://github.com/folke/flash.nvim",
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/kdheepak/lazygit.nvim",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/RRethy/nvim-treesitter-endwise",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/calops/hmts.nvim",
  -- Folding
  "https://github.com/kevinhwang91/promise-async",
  "https://github.com/kevinhwang91/nvim-ufo",
  -- Editing
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
}, { confirm = false })

require("plugins.eldritch")
require("plugins.bufferline")
require("plugins.fff")
require("plugins.flash")
require("plugins.gitsigns")
require("plugins.kitty-scrollback")
require("plugins.mini-pairs")
require("plugins.mini-surround")
require("plugins.native-ui")
require("plugins.persistence")
require("plugins.conform")
require("plugins.lint")
require("plugins.fidget")
require("plugins.lsp")
require("plugins.todo-comments")
require("plugins.treesitter")
require("plugins.treesitter-context")
require("plugins.ufo")
require("plugins.hmts")
require("plugins.tiny-inline-diagnostic")
require("plugins.trouble")
require("plugins.which-key")
require("plugins.yazi")
