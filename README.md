# Neonvoid's Neovim Configuration

A modern, feature-rich Neovim configuration built with [nvf](https://github.com/notashelf/nvf) — a Nix-native Neovim framework.

## 🚀 Quick Start

```bash
nix run github:neonvoidx/nvim   # run directly
nix build github:neonvoidx/nvim # build
```

Or add as flake input:

```bash
  inputs = {
    nvim.url = "github:neonvoidx/nvim";
  }
```

Or clone and run locally:

```bash
git clone git@github.com:neonvoidx/nvim.git ~/nvim
cd ~/nvim
nix run .#
```

## 📋 Requirements

- Nix with flakes enabled
- A Nerd Font (for icons)
- Kitty terminal (for navigator integration)

## 📁 Structure

```
flake.nix          # Flake inputs, userPlugins, package output
flake.lock         # Pinned inputs
config/
  default.nix      # Imports all plugin modules
  options.nix      # Neovim options
  keymaps.nix      # Global keymaps
  autocmds.nix     # Autocommands
plugins/           # One .nix file per feature area
snippets/          # Custom VSCode-format snippets
stylua.toml        # Lua formatter config (120-col, 2-space, double quotes)
```

## 📦 Plugins

### 🎨 UI & Appearance

- [eldritch.nvim](https://github.com/eldritch-theme/eldritch.nvim) — Colorscheme
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) — Statusline
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) — Buffer tabs
- [snacks.nvim](https://github.com/folke/snacks.nvim) — Dashboard, picker, notifier, indent guides, scrollbar, lazygit, and more
- [noice.nvim](https://github.com/folke/noice.nvim) — Enhanced cmdline/messages UI
- [which-key.nvim](https://github.com/folke/which-key.nvim) — Keybinding hints
- [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) — Inline color previews
- [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim) — Inline diagnostics

### 💻 LSP & Completion

- [blink.cmp](https://github.com/Saghen/blink.cmp) — Completion engine
- [blink-copilot](https://github.com/giuxtaposition/blink-copilot) — Copilot source for blink.cmp
- [lazydev.nvim](https://github.com/folke/lazydev.nvim) — Neovim Lua API completions
- [clangd_extensions.nvim](https://github.com/p00f/clangd_extensions.nvim) — Enhanced clangd
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) — Rust tooling
- [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim) — Incremental LSP rename
- [trouble.nvim](https://github.com/folke/trouble.nvim) — Diagnostics list

### 🤖 AI

- [copilot.lua](https://github.com/zbirenbaum/copilot.lua) — GitHub Copilot

### 🌳 Treesitter

- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — Syntax highlighting & more
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) — Sticky context header
- [nvim-treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise) — Auto-close blocks
- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) — Context-aware comments

### 🔍 Navigation & Search

- [flash.nvim](https://github.com/folke/flash.nvim) — Jump anywhere with minimal keystrokes
- [yazi.nvim](https://github.com/mikavilpas/yazi.nvim) — File manager integration
- [yanky.nvim](https://github.com/gbprod/yanky.nvim) — Enhanced yank/paste ring
- [numb.nvim](https://github.com/nacro90/numb.nvim) — Peek line numbers
- [vim-illuminate](https://github.com/RRethy/vim-illuminate) — Highlight word under cursor

### 📝 Editing

- [mini.pairs](https://github.com/echasnovski/mini.pairs) — Auto-pair brackets
- [mini.surround](https://github.com/echasnovski/mini.surround) — Surround operations
- [nvim-scissors](https://github.com/chrisgrieser/nvim-scissors) — Snippet editor
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) — Snippet collection

### 🔧 Formatting & Linting

- [conform.nvim](https://github.com/stevearc/conform.nvim) — Code formatting
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) — Linting

### 📂 Git

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) — Git decorations & hunks
- [diffview.nvim](https://github.com/sindrets/diffview.nvim) — Diff & merge tool
- [resolved.nvim](https://github.com/noamsto/resolved.nvim) — Merge conflict resolver

### 📄 Markdown

- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) — In-editor rendering
- [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) — Obsidian vault integration
- [markdown-toc.nvim](https://github.com/hedyhli/markdown-toc.nvim) — TOC generator

### 🛠️ Utilities

- [persistence.nvim](https://github.com/folke/persistence.nvim) — Session management
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) — Modern folding
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) — TODO highlights
- [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) — Auto-detect indentation

### 🐱 Kitty

- [vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator) — Seamless pane navigation (`<C-h/j/k/l>`)

## ⚙️ Highlights

| Setting | Value |
|---|---|
| Leader | `Space` |
| Tab width | 2 spaces |
| Line numbers | Relative |
| Completion | blink.cmp + Copilot |
| Formatter | conform.nvim (format on save disabled, manual) |
| LSP API | `vim.lsp.config` + `vim.lsp.enable` (nvim 0.11) |
| Session | `<leader>qs` restore · `<leader>qS` select · `<leader>ql` last |

## 🔑 Key Bindings (highlights)

| Key | Action |
|---|---|
| `<leader><space>` | Smart find files |
| `<leader>/` | Grep |
| `<leader>gg` | Lazygit |
| `<leader>qs` | Restore session |
| `<leader>cr` | Rename symbol |
| `<C-h/j/k/l>` | Navigate panes (nvim + kitty) |

## 📝 License

Personal configuration — feel free to use and modify as needed.
