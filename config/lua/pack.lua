-- vim.pack: plugins are cloned into {data}/site/pack/core/opt and locked in our
-- own state dir. Requires `git` (Nix-provided).
--
-- The default 'packlockfile' is hardcoded to $XDG_CONFIG_HOME/nvim/…, i.e. it
-- would collide with any other Neovim config on this machine. Isolate it.
vim.opt.packlockfile = vim.fn.stdpath("state") .. "/pack-lock.json"

-- Order matters: each plugin is `:packadd!`-ed in order, so dependencies come
-- before their consumers.
local function add(plugins)
  local ok, err = pcall(vim.pack.add, plugins, { confirm = false })
  if not ok then
    vim.notify("vim.pack: " .. tostring(err), vim.log.levels.WARN)
  end
end

add({
  -- colorscheme
  { src = "https://github.com/eldritch-theme/eldritch.nvim" },
  -- dependencies
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/tpope/vim-repeat" },
  { src = "https://github.com/kevinhwang91/promise-async" },
  -- UI
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  -- editing / motion
  { src = "https://github.com/echasnovski/mini.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/gbprod/yanky.nvim" },
  -- LSP tooling
  { src = "https://github.com/smjonas/inc-rename.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  -- formatting / linting
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  -- context / helpers
  { src = "https://github.com/RRethy/vim-illuminate" },
  { src = "https://github.com/nacro90/numb.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/NMAC427/guess-indent.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  -- sessions / buffers / git
  { src = "https://github.com/folke/persistence.nvim" },
  { src = "https://github.com/kevinhwang91/nvim-ufo" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  -- navigation / file management
  { src = "https://github.com/smart-splits-nvim/smart-splits.nvim" },
  { src = "https://github.com/mikavilpas/yazi.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
})