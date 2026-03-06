# Neonvoid's Neovim Configuration

A modern, feature-rich Neovim configuration built with Lua, powered by [lze](https://github.com/BirdeeHub/lze) and packaged with Nix.
(ya I made AI generate this README)

## 📋 Requirements

- Neovim >= 0.11.5
- Git
- A Nerd Font (for icons)
- **Nix mode**: Nix with flakes enabled
- **Non-Nix mode**: Neovim >= 0.11 (plugins bootstrapped via `vim.pack.add`)

## 🚀 Features

- **Dual-mode**: works under Nix (via `nix-wrapper-modules`) or standalone without Nix
- **Fast startup** with lazy loading via `lze`
- **LSP integration** with auto-completion and diagnostics
- **AI assistance** with GitHub Copilot integration
- **Git integration** with signs, blame, and diff views
- **Treesitter** for advanced syntax highlighting
- **File navigation** with yazi
- **Session management** and persistence
- **Markdown support** with preview, TOC generation, and Obsidian vault support
- **Task runner** with Overseer
- **Custom snippets** and auto-pairing

## ❄️ Nix Usage

```bash
nix build .#           # Build the wrapped Neovim derivation
nix run .#             # Run Neovim directly
nix flake update       # Update all flake inputs (plugins, nixpkgs)
```

The flake also exports `nixosModules.default` and `homeModules.default` for system/home-manager integration.

## 📦 Plugins

### 🎨 UI & Appearance

- [eldritch.nvim](https://github.com/eldritch-theme/eldritch.nvim) - Colorscheme
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer tabs
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) - File icons
- [noice.nvim](https://github.com/folke/noice.nvim) - Enhanced UI for messages, cmdline and popups
- [nui.nvim](https://github.com/MunifTanjim/nui.nvim) - UI component library
- [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) - Color highlighter
- [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) - Inline diagnostics
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding hints

### 💻 LSP & Completion

- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configurations
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP/DAP/linter installer (non-Nix only)
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - Mason LSP integration
- [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) - Auto-install tools
- [blink.cmp](https://github.com/Saghen/blink.cmp) - Completion engine
- [blink-copilot](https://github.com/fang2hou/blink-copilot) - Copilot source for blink.cmp
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim) - VSCode-like pictograms
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) - Neovim Lua API completion
- [SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim) - JSON/YAML schema catalog
- [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim) - Enhanced clangd features
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) - Rust tooling

### 🤖 AI & Copilot

- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot
- [copilot-lsp](https://github.com/copilotlsp-nvim/copilot-lsp) - Copilot LSP integration
- [sidekick.nvim](https://github.com/liubianshi/sidekick.nvim) - AI sidebar utilities

### 🌳 Treesitter

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter configurations
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) - Context sticky header
- [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise) - Auto-add end statements
- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) - Context-aware comments

### 🔍 Navigation & Search

- [flash.nvim](https://github.com/folke/flash.nvim) - Enhanced motion navigation
- [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) - File manager integration
- [numb.nvim](https://github.com/nacro90/numb.nvim) - Peek line numbers
- [vim-illuminate](https://github.com/RRethy/vim-illuminate) - Highlight word under cursor

### 📝 Editing

- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Auto-pair brackets
- [mini.surround](https://github.com/echasnovski/mini.surround) - Surround operations
- [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim) - Incremental LSP rename
- [nvim-scissors](https://github.com/chrisgrieser/nvim-scissors) - Snippet management
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Snippet collection
- [yanky.nvim](https://github.com/gbprod/yanky.nvim) - Enhanced yank/paste
- [quicker.nvim](https://github.com/stevearc/quicker.nvim) - Enhanced quickfix list

### 🔧 Formatting & Linting

- [conform.nvim](https://github.com/stevearc/conform.nvim) - Code formatter
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) - Linting

### 📂 Git Integration

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git decorations
- [git-blame.nvim](https://github.com/f-person/git-blame.nvim) - Git blame
- [git-scripts.nvim](https://github.com/lommix/git-scripts.nvim) - Git scripts
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) - Git diff viewer
- [resolved.nvim](https://github.com/aMOPel/resolved.nvim) - Merge conflict resolver

### 📄 Markdown

- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - Markdown preview
- [markdown-toc.nvim](https://github.com/hedyhli/markdown-toc.nvim) - Table of contents generator
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - Markdown renderer
- [obsidian.nvim](https://github.com/obsidian-nvim/obsidian.nvim) - Obsidian vault integration
- [presenting.nvim](https://github.com/sotte/presenting.nvim) - Presentation mode

### 🛠️ Utilities

- [snacks.nvim](https://github.com/folke/snacks.nvim) - Useful utilities (terminal, git, rename, picker)
- [overseer.nvim](https://github.com/stevearc/overseer.nvim) - Task runner
- [persistence.nvim](https://github.com/folke/persistence.nvim) - Session management
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - TODO comments highlighter
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Diagnostics list
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) - Modern folding
- [promise-async](https://github.com/kevinhwang91/promise-async) - Async promise library
- [helpview.nvim](https://github.com/OXY2DEV/helpview.nvim) - Enhanced help viewer
- [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) - Auto-detect indent

### 🐱 Kitty Integration

- [vim-kitty](https://github.com/fladson/vim-kitty) - Kitty config syntax
- [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator) - Seamless navigation
- [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) - Kitty scrollback

### ❄️ Nix Integration

- [hmts.nvim](https://github.com/calops/hmts.nvim) - Home Manager treesitter injections
- [vim-nix](https://github.com/LnL7/vim-nix) - Nix syntax support

### 🎨 Colorschemes

- [eldritch.nvim](https://github.com/eldritch-theme/eldritch.nvim) - Primary colorscheme (from flake input)
- [catppuccin](https://github.com/catppuccin/nvim) - Alternate
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Alternate
- [dracula.nvim](https://github.com/Mofiqul/dracula.nvim) - Alternate
- [onedark.nvim](https://github.com/navarasu/onedark.nvim) - Alternate
- [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) - Alternate

### 📚 Core Dependencies

- [lze](https://github.com/BirdeeHub/lze) - Plugin loader (replaces lazy.nvim)
- [lzextras](https://github.com/BirdeeHub/lzextras) - Extra lze handlers (LSP, etc.)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua utilities

## 📁 Structure

```
~/.config/nvim/
├── init.lua                 # Entry point: nix/non-nix detection, plugin bootstrap, lze setup
├── flake.nix                # Flake inputs, overlay, package/module outputs
├── module.nix               # nix-wrapper-modules spec: plugin lists, LSPs, formatters in PATH
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lze.lua         # Loads all plugin modules via lze.load()
│   │   └── opts.lua        # Neovim options
│   └── plugins/            # Plugin configurations (one file per feature area)
├── snippets/               # Custom VSCode-format snippets
└── stylua.toml            # Lua formatter config (120-col, 2-space, double quotes)
```

## ⚙️ Configuration Highlights

- **Leader key**: Space
- **Tab width**: 2 spaces
- **Line numbers**: Relative
- **Auto-save**: Enabled
- **Mouse**: Enabled in normal and visual modes
- **Clipboard**: Synced with system (with WSL support)
- **Diagnostics**: Inline with custom icons

## 🎯 Key Features by Plugin

### lze
- Lightweight plugin loader (replaces lazy.nvim)
- Combined with lzextras for LSP handler support
- `User VeryLazy` event emitted manually via `UIEnter` autocmd

### Blink.cmp

- Fast, async completion engine
- GitHub Copilot integration
- Snippet support

### Snacks.nvim

- Collection of useful utilities
- Terminal integration
- Git utilities
- Rename utilities

### Flash.nvim

- Enhanced f/F/t/T motions
- Jump to any location with minimal keystrokes

### Overseer.nvim

- Task runner and job management
- Build system integration

### Persistence.nvim

- Automatic session management
- Restore last session on startup

## 📝 License

Personal configuration - feel free to use and modify as needed.
