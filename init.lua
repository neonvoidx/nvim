vim.loader.enable()

-- When running headless (CI / health checks), avoid heavy UI/plugin startup.
-- This also makes it easier to run `nvim --headless '+qall'` without hanging.
if not vim.g.__nvim_full_startup and (#vim.api.nvim_list_uis() == 0) then
  vim.g.__nvim_full_startup = false
end

-- ============================================================
-- Bootstrap: Nix or non-nix detection
-- ============================================================
do
  local ok
  ok, _G.nixInfo = pcall(require, vim.g.nix_info_plugin_name or "__nonexistent__")
  if not ok then
    -- Non-nix: bootstrap all plugins via vim.pack.add (nvim >= 0.11)
    _G.nixInfo = setmetatable({}, { __call = function(_, default) return default end })
    nixInfo.isNix = false

    -- Prefer the built-in vim.pack (0.11+), but fall back to a minimal git clone
    -- bootstrap when vim.pack isn't available (some distributions disable it).
    local function bootstrap_git(plugin)
      local url = plugin
      local name
      if type(plugin) == "table" then
        url = plugin.src
        name = plugin.name
      end
      if type(url) ~= "string" then
        return
      end
      name = name or url:gsub("/$", ""):match("/([^/]+)$")

      local pack_root = vim.fn.stdpath("data") .. "/site/pack/bootstrap/start/"
      local install_path = pack_root .. name
      if vim.fn.isdirectory(install_path) == 0 then
        vim.fn.mkdir(pack_root, "p")
        vim.system({ "git", "clone", "--filter=blob:none", "--depth=1", url, install_path }):wait()
      end
    end

    local plugins = {
      -- lze ecosystem
      "https://github.com/BirdeeHub/lze",
      "https://github.com/BirdeeHub/lzextras",
      -- Core UI
      "https://github.com/folke/snacks.nvim",
      "https://github.com/folke/noice.nvim",
      "https://github.com/MunifTanjim/nui.nvim",
      -- Which-key / navigation
      "https://github.com/folke/which-key.nvim",
      "https://github.com/folke/flash.nvim",
      "https://github.com/folke/todo-comments.nvim",
      -- LSP
      "https://github.com/neovim/nvim-lspconfig",
      "https://github.com/RRethy/vim-illuminate",
      "https://github.com/folke/trouble.nvim",
      "https://github.com/folke/lazydev.nvim",
      "https://github.com/mrcjkb/rustaceanvim",
      "https://github.com/p00f/clangd_extensions.nvim",
      "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
      "https://github.com/onsails/lspkind.nvim",
      "https://github.com/smjonas/inc-rename.nvim",
      "https://github.com/b0o/SchemaStore.nvim",
      -- Mason (non-nix only)
      "https://github.com/mason-org/mason.nvim",
      "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
      "https://github.com/mason-org/mason-lspconfig.nvim",
      -- Completion
      "https://github.com/saghen/blink.cmp",
      { src = "https://github.com/fang2hou/blink-copilot", name = "blink-copilot" },
      -- AI
      { src = "https://github.com/zbirenbaum/copilot.lua", name = "copilot.lua" },
      { src = "https://github.com/copilotlsp-nvim/copilot-lsp", name = "copilot-lsp" },
      "https://github.com/folke/sidekick.nvim",
      -- Treesitter
      "https://github.com/nvim-treesitter/nvim-treesitter",
      "https://github.com/RRethy/nvim-treesitter-endwise",
      "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
      "https://github.com/nvim-treesitter/nvim-treesitter-context",
      -- Format / Lint
      { src = "https://github.com/stevearc/conform.nvim", name = "conform.nvim" },
      "https://github.com/mfussenegger/nvim-lint",
      -- Git
      "https://github.com/lewis6991/gitsigns.nvim",
      "https://github.com/f-person/git-blame.nvim",
      "https://github.com/declancm/git-scripts.nvim",
      "https://github.com/noamsto/resolved.nvim",
      "https://github.com/sindrets/diffview.nvim",
      -- Status / buffers
      "https://github.com/nvim-lualine/lualine.nvim",
      "https://github.com/akinsho/bufferline.nvim",
      "https://github.com/nvim-tree/nvim-web-devicons",
      -- Editing helpers
      "https://github.com/echasnovski/mini.pairs",
      "https://github.com/echasnovski/mini.surround",
      "https://github.com/gbprod/yanky.nvim",
      "https://github.com/NMAC427/guess-indent.nvim",
      "https://github.com/nacro90/numb.nvim",
      "https://github.com/OXY2DEV/helpview.nvim",
      "https://github.com/brenoprata10/nvim-highlight-colors",
      "https://github.com/smjonas/inc-rename.nvim",
      -- Folds
      "https://github.com/kevinhwang91/nvim-ufo",
      "https://github.com/kevinhwang91/promise-async",
      -- Snippets
      "https://github.com/chrisgrieser/nvim-scissors",
      "https://github.com/rafamadriz/friendly-snippets",
      -- Themes
      { src = "https://github.com/eldritch-theme/eldritch.nvim", name = "eldritch.nvim" },
      { src = "https://github.com/catppuccin/nvim", name = "catppuccin-nvim" },
      { src = "https://github.com/folke/tokyonight.nvim", name = "tokyonight.nvim" },
      { src = "https://github.com/Mofiqul/dracula.nvim", name = "dracula.nvim" },
      { src = "https://github.com/navarasu/onedark.nvim", name = "onedark.nvim" },
      { src = "https://github.com/EdenEast/nightfox.nvim", name = "nightfox.nvim" },
      -- Markdown
      { src = "https://github.com/iamcco/markdown-preview.nvim", name = "markdown-preview.nvim" },
      "https://github.com/MeanderingProgrammer/render-markdown.nvim",
      { src = "https://github.com/obsidian-nvim/obsidian.nvim", name = "obsidian.nvim" },
      { src = "https://github.com/sotte/presenting.nvim", name = "presenting.nvim" },
      { src = "https://github.com/hedyhli/markdown-toc.nvim", name = "markdown-toc.nvim" },
      -- Session / misc
      { src = "https://github.com/folke/persistence.nvim", name = "persistence.nvim" },
      "https://github.com/stevearc/overseer.nvim",
      "https://github.com/stevearc/quicker.nvim",
      "https://github.com/calops/hmts.nvim",
      -- Navigation
      "https://github.com/mikavilpas/yazi.nvim",
      "https://github.com/nvim-lua/plenary.nvim",
      -- Kitty
      "https://github.com/knubie/vim-kitty-navigator",
      { src = "https://github.com/mikesmithgh/kitty-scrollback.nvim", name = "kitty-scrollback.nvim" },
      { src = "https://github.com/fladson/vim-kitty", name = "vim-kitty" },
      -- Nix
      "https://github.com/LnL7/vim-nix",
    }

    if vim.g.__nvim_full_startup == false then
      -- Minimal headless path: don't bootstrap/clone plugins.
      -- Config modules may still be required by downstream commands.
    elseif type(vim.pack) == "table" and type(vim.pack.add) == "function" then
      vim.pack.add(plugins, { load = function() end, confirm = false })
    else
      for _, p in ipairs(plugins) do
        bootstrap_git(p)
      end
      vim.cmd("packloadall")
    end

    -- With vim.pack.add(), plugins are immediately available on 'packpath'.
    -- packadd is still fine, but only works for opt packages; keep it guarded.
    pcall(vim.cmd.packadd, "lze")
    pcall(vim.cmd.packadd, "lzextras")
  else
    nixInfo.isNix = true
  end

  -- Merge lzextras methods into lze for unified API
  if vim.g.__nvim_full_startup == false then
    nixInfo.lze = { register_handlers = function() end }
  else
    nixInfo.lze = setmetatable(require("lze"), getmetatable(require("lzextras")))
  end
end

-- Register lze handlers
if vim.g.__nvim_full_startup ~= false then
  nixInfo.lze.register_handlers(require("lzextras").lsp)
end

-- ============================================================
-- Core settings
-- ============================================================
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.mason_disabled = nixInfo.isNix

-- ============================================================
-- Load config modules
-- ============================================================
require("config.autocmds")
require("config.opts")
require("config.keymaps")
require("config.lze")
