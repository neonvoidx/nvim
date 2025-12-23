# Neonvoid's Neovim Configuration

A modern, feature-rich Neovim configuration built with Lua and powered by [lazy.nvim](https://github.com/folke/lazy.nvim).
(ya I made AI generate this README)

> **📦 NEW: Nixvim Port Available!**  
> This configuration is now available as a [nixvim](https://nix-community.github.io/nixvim/) port on the `nixvim` branch.  
> See [NIXVIM.md](NIXVIM.md) for details on using the Nix-based configuration.

## 📋 Requirements

- Neovim >= 0.11.5
- Git
- A Nerd Font (for icons)

## 🚀 Features

- **Fast startup** with lazy loading
- **LSP integration** with auto-completion and diagnostics
- **AI assistance** with GitHub Copilot integration
- **Git integration** with signs, blame, and diff views
- **Treesitter** for advanced syntax highlighting
- **Fuzzy finding** and file navigation
- **Session management** and persistence
- **Markdown support** with preview and TOC generation
- **Task runner** with Overseer
- **Custom snippets** and auto-pairing

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
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP/DAP/linter installer
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - Mason LSP integration
- [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) - Auto-install tools
- [blink.cmp](https://github.com/Saghen/blink.cmp) - Completion engine
- [blink-copilot](https://github.com/giuxtaposition/blink-copilot) - Copilot source for blink.cmp
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim) - VSCode-like pictograms
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) - Neovim Lua API completion
- [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim) - Enhanced clangd features
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) - Rust tooling

### 🤖 AI & Copilot

- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot
- [copilot-lsp](https://github.com/zbirenbaum/copilot-cmp) - Copilot LSP integration

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
- [presenting.nvim](https://github.com/sotte/presenting.nvim) - Presentation mode

### 🛠️ Utilities

- [snacks.nvim](https://github.com/folke/snacks.nvim) - Useful snippets and utilities
- [overseer.nvim](https://github.com/stevearc/overseer.nvim) - Task runner
- [persistence.nvim](https://github.com/folke/persistence.nvim) - Session management
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - TODO comments highlighter
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Diagnostics list
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) - Modern folding
- [promise-async](https://github.com/kevinhwang91/promise-async) - Async promise library
- [helpview.nvim](https://github.com/OXY2DEV/helpview.nvim) - Enhanced help viewer
- [sidekick.nvim](https://github.com/liubianshi/sidekick.nvim) - Sidebar utilities
- [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) - Auto-detect indent

### 🐱 Kitty Integration

- [vim-kitty](https://github.com/fladson/vim-kitty) - Kitty config syntax
- [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator) - Seamless navigation
- [kitty-scrollback.nvim](https://github.com/mikesmithgh/kitty-scrollback.nvim) - Kitty scrollback

### 📚 Core Dependencies

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua utilities

## 📁 Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua    # Auto commands
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   ├── opts.lua        # Neovim options
│   │   └── util.lua        # Utility functions
│   └── plugins/            # Plugin configurations
├── snippets/               # Custom snippets
└── stylua.toml            # Lua formatter config
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
