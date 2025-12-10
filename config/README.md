# Nixvim Configuration for neonvoidx/nvim

This is a complete port of the [lazy.nvim configuration](https://github.com/neonvoidx/nvim) to [nixvim](https://nix-community.github.io/nixvim/), a Nix-based Neovim configuration framework.

## Overview

This configuration has been ported from a Lua-based lazy.nvim setup to a declarative Nix-based nixvim configuration. The port maintains feature parity with the original configuration while leveraging Nix's reproducibility and declarative nature.

## Structure

```
config/
├── default.nix           # Main entry point
├── options.nix          # Neovim options (from lua/config/opts.lua)
├── keymaps.nix          # Keybindings (from lua/config/keymaps.lua)
├── autocommands.nix     # Autocommands (from lua/config/autocmds.lua)
└── plugins/             # Plugin configurations
    ├── default.nix      # Plugin imports
    ├── lsp.nix          # LSP configuration (mason, lspconfig, etc.)
    ├── completion.nix   # Blink.cmp completion engine
    ├── treesitter.nix   # Treesitter configuration
    ├── ui.nix           # UI plugins (lualine, bufferline, noice, which-key)
    ├── editing.nix      # Editing plugins (mini, flash, yanky, etc.)
    ├── git.nix          # Git plugins (gitsigns, diffview, git-blame)
    ├── utilities.nix    # Utility plugins (snacks, overseer, persistence, yazi)
    ├── markdown.nix     # Markdown plugins (preview, render, toc)
    ├── formatting.nix   # Formatting & linting (conform, nvim-lint)
    ├── kitty.nix        # Kitty terminal integration
    └── ai.nix           # AI plugins (copilot, sidekick)
```

## Installation

### With Home Manager

Add this to your Home Manager configuration:

```nix
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    
    # Import the configuration
    imports = [ ./path/to/config ];
  };
}
```

### Standalone

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { nixpkgs, nixvim, ... }: {
    packages.x86_64-linux.default = nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      module = ./config;
    };
  };
}
```

## Features Ported

### Core Features
- ✅ **Leader key**: Space
- ✅ **Local leader**: Backslash
- ✅ **Color scheme**: Eldritch theme
- ✅ **Options**: All Neovim options from opts.lua
- ✅ **Keymaps**: All keybindings from keymaps.lua
- ✅ **Autocommands**: All autocommands from autocmds.lua

### LSP & Completion
- ✅ **LSP Servers**: bashls, jsonls, gopls, lua_ls, basedpyright, yamlls, dockerls, docker_compose_language_service, neocmake, vtsls, terraformls, clangd, zls, emmet_language_server, fish_lsp
- ✅ **Mason**: LSP/DAP/linter installer
- ✅ **Blink.cmp**: Fast async completion engine with Copilot integration
- ✅ **LazyDev**: Neovim Lua API completion
- ✅ **Rustaceanvim**: Rust tooling
- ✅ **Clangd Extensions**: Enhanced clangd features
- ✅ **Trouble**: Diagnostics list
- ✅ **Illuminate**: Highlight word under cursor
- ✅ **Tiny Inline Diagnostic**: Inline diagnostics display

### Treesitter
- ✅ **Treesitter**: Syntax highlighting with 30+ languages
- ✅ **Treesitter Context**: Sticky header showing context
- ✅ **Context Commentstring**: Context-aware comments
- ✅ **Treesitter Endwise**: Auto-add end statements

### UI Plugins
- ✅ **Lualine**: Statusline
- ✅ **Bufferline**: Buffer tabs
- ✅ **Noice**: Enhanced UI for messages/cmdline/popups
- ✅ **Which-key**: Keybinding hints
- ✅ **Web Devicons**: File icons
- ✅ **Nvim Colorizer**: Color highlighter
- ✅ **Todo Comments**: TODO/FIXME/NOTE highlighting
- ✅ **Helpview**: Enhanced help viewer

### Editing Plugins
- ✅ **Mini.pairs**: Auto-pair brackets
- ✅ **Mini.surround**: Surround operations
- ✅ **Flash**: Enhanced motion navigation
- ✅ **Yanky**: Enhanced yank/paste with history
- ✅ **Numb**: Peek line numbers
- ✅ **Inc-rename**: Incremental LSP rename
- ✅ **Guess-indent**: Auto-detect indentation
- ✅ **Nvim-ufo**: Modern folding
- ✅ **Nvim-scissors**: Snippet management
- ✅ **Friendly-snippets**: Snippet collection

### Git Integration
- ✅ **Gitsigns**: Git decorations and inline blame
- ✅ **Git-blame**: Git blame display
- ✅ **Diffview**: Git diff viewer
- ✅ **Resolved**: Merge conflict resolver
- ✅ **Git-scripts**: Auto-commit for vault (Obsidian notes)

### Utilities
- ✅ **Snacks**: Collection of useful utilities
- ✅ **Overseer**: Task runner
- ✅ **Persistence**: Session management
- ✅ **Yazi**: File manager integration

### Markdown
- ✅ **Markdown Preview**: Live markdown preview
- ✅ **Render Markdown**: In-editor markdown rendering
- ✅ **Markdown TOC**: Table of contents generator
- ✅ **Presenting**: Presentation mode

### Formatting & Linting
- ✅ **Conform**: Code formatter with support for stylua, black, isort, prettierd, etc.
- ✅ **Nvim-lint**: Linting with pylint, eslint_d, yamllint, etc.

### Terminal Integration
- ✅ **Kitty**: Syntax highlighting for Kitty configs
- ✅ **Kitty Navigator**: Seamless navigation between Kitty and Neovim
- ✅ **Kitty Scrollback**: Enhanced scrollback

### AI & Copilot
- ✅ **Copilot.lua**: GitHub Copilot integration
- ✅ **Sidekick**: CLI AI assistant integration (Copilot/Aider)

## Key Differences from Original

1. **Plugin Management**: Uses Nix instead of lazy.nvim for plugin management
2. **Declarative Configuration**: All configuration is declarative in Nix
3. **Reproducibility**: Nix ensures the exact same configuration on any system
4. **Custom Plugins**: Some plugins that aren't in nixpkgs are added as `extraPlugins`

## Notes on Plugin Availability

Some plugins are not yet available in nixvim's built-in plugins and are configured as `extraPlugins`:

- blink.cmp (completion engine)
- blink-copilot (copilot source for blink)
- snacks.nvim
- sidekick.nvim
- resolved.nvim
- git-scripts.nvim
- markdown-toc.nvim
- presenting.nvim
- vim-kitty-navigator
- kitty-scrollback.nvim

These will need their `sha256` hashes filled in when actually building the configuration.

## WSL Support

The configuration includes automatic WSL clipboard detection and configuration, just like the original.

## Custom Commands

- `MasonUpgrade`: Upgrade all installed Mason packages

## Keybinding Groups

- `<leader>a`: AI commands
- `<leader>b`: Buffer management
- `<leader>c`: Code actions (LSP)
- `<leader>e`: File explorer (Yazi)
- `<leader>f`: Find (fuzzy finding)
- `<leader>g`: Git operations
- `<leader>l`: LSP commands
- `<leader>m`: Markdown commands
- `<leader>n`: Notifications
- `<leader>o`: Overseer (task runner)
- `<leader>q`: Session management
- `<leader>s`: Search
- `<leader>t`: Toggle options
- `<leader>u`: UI commands
- `<leader>w`: Window management
- `<leader>x`: Trouble (diagnostics)

## Building the SHA256 Hashes

For the `extraPlugins` that need SHA256 hashes, you can use:

```bash
nix-prefetch-git https://github.com/owner/repo --rev branch-or-tag
```

## Contributing

This is a port of an existing configuration. For feature requests or changes to the core configuration, please refer to the [original repository](https://github.com/neonvoidx/nvim).

## License

Same as the original configuration - personal configuration, feel free to use and modify as needed.

## Resources

- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Nixvim Options Search](https://nix-community.github.io/nixvim/search/)
- [Original Configuration](https://github.com/neonvoidx/nvim)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
