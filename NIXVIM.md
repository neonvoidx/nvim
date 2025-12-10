# Nixvim Configuration Port

This branch contains a complete port of the Neovim configuration to [nixvim](https://nix-community.github.io/nixvim/), a Nix-based Neovim configuration framework.

## What is Nixvim?

Nixvim is a NixOS module for configuring Neovim using the Nix language. It provides:

- **Declarative configuration**: Define your entire Neovim setup in Nix
- **Reproducibility**: Same configuration works identically across systems
- **Nix ecosystem integration**: Leverage Nix packages and dependency management
- **Type safety**: Catch configuration errors at build time

## Configuration Location

The nixvim configuration is located in the `config/` directory:

```
config/
├── default.nix           # Main entry point
├── options.nix          # Neovim options
├── keymaps.nix          # Keybindings
├── autocommands.nix     # Autocommands
└── plugins/             # Plugin configurations
    ├── default.nix      # Plugin imports
    ├── lsp.nix          # LSP & diagnostics
    ├── completion.nix   # Completion engine
    ├── treesitter.nix   # Syntax highlighting
    ├── ui.nix           # UI plugins
    ├── editing.nix      # Editing enhancements
    ├── git.nix          # Git integration
    ├── utilities.nix    # Utility plugins
    ├── markdown.nix     # Markdown support
    ├── formatting.nix   # Code formatting & linting
    ├── kitty.nix        # Terminal integration
    └── ai.nix           # AI & Copilot
```

## Quick Start

### Using with Home Manager

Add to your Home Manager configuration:

```nix
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    imports = [ ./config ];
  };
}
```

Then rebuild:

```bash
home-manager switch
```

### Using with NixOS

Add to your NixOS configuration:

```nix
{
  programs.nixvim = {
    enable = true;
    imports = [ ./config ];
  };
}
```

Then rebuild:

```bash
sudo nixos-rebuild switch
```

### Standalone Flake

Create a `flake.nix`:

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

Then run:

```bash
nix run .
```

## Features

This nixvim port maintains complete feature parity with the original lazy.nvim configuration:

### Core
- ✅ Leader key: Space
- ✅ Eldritch colorscheme
- ✅ All keybindings preserved
- ✅ All autocommands preserved
- ✅ All Neovim options preserved

### LSP & Completion
- ✅ 15+ LSP servers (Lua, TypeScript, Python, Rust, C/C++, Go, etc.)
- ✅ Mason for LSP/tool installation
- ✅ Blink.cmp completion engine
- ✅ GitHub Copilot integration
- ✅ Trouble for diagnostics
- ✅ LazyDev for Neovim Lua API

### Treesitter
- ✅ 30+ language grammars
- ✅ Context sticky header
- ✅ Context-aware comments
- ✅ Auto-add end statements

### UI
- ✅ Lualine statusline
- ✅ Bufferline tabs
- ✅ Noice enhanced UI
- ✅ Which-key keybinding hints
- ✅ Color highlighting
- ✅ TODO comments
- ✅ Inline diagnostics

### Editing
- ✅ Auto-pairs
- ✅ Surround operations
- ✅ Flash motion navigation
- ✅ Yanky enhanced yank/paste
- ✅ Modern folding (nvim-ufo)
- ✅ Incremental rename
- ✅ Snippet support

### Git
- ✅ Gitsigns decorations
- ✅ Git blame
- ✅ Diffview
- ✅ Merge conflict resolution
- ✅ Auto-commit for vault (Obsidian)

### Utilities
- ✅ Snacks.nvim utilities
- ✅ Overseer task runner
- ✅ Session management
- ✅ Yazi file manager
- ✅ Guess indent

### Markdown
- ✅ Live preview
- ✅ In-editor rendering
- ✅ TOC generation
- ✅ Presentation mode

### Formatting & Linting
- ✅ Conform formatter
- ✅ Nvim-lint linter
- ✅ Format on save

### Terminal
- ✅ Kitty integration
- ✅ Seamless navigation
- ✅ Enhanced scrollback

### AI
- ✅ GitHub Copilot
- ✅ Sidekick AI CLI
- ✅ Aider integration

## Original Configuration

The original lazy.nvim configuration is still available on the `master` branch. You can use either configuration:

- **master branch**: Lua-based lazy.nvim configuration (traditional)
- **nixvim branch**: Nix-based nixvim configuration (this branch)

## Key Differences

| Aspect | lazy.nvim (master) | nixvim (this branch) |
|--------|-------------------|---------------------|
| Plugin manager | lazy.nvim | Nix |
| Configuration language | Lua | Nix (+ Lua for complex logic) |
| Installation | Clone repo to `~/.config/nvim` | Integrated with Nix |
| Updates | `:Lazy update` | `nix flake update` or system rebuild |
| Reproducibility | Depends on timing | Complete via Nix |
| Portability | Manual sync | Automatic via Nix |

## Documentation

For detailed information about the nixvim configuration, see [config/README.md](config/README.md).

## Resources

- [Nixvim Documentation](https://nix-community.github.io/nixvim/)
- [Nixvim Options Search](https://nix-community.github.io/nixvim/search/)
- [NixOS Wiki - Neovim](https://nixos.wiki/wiki/Neovim)
- [Original lazy.nvim config](../master)

## Support

For issues specific to:
- **Nixvim port**: Open an issue on this branch
- **Original config**: See the master branch
- **Nixvim framework**: Visit [nixvim repository](https://github.com/nix-community/nixvim)

## License

Personal configuration - feel free to use and modify as needed.
