# Neovim Configuration

## Custom Neovim Config

A clean, modern Neovim configuration optimized for development.

### Requirements

- Neovim 0.11 or higher
- Git
- A Nerd Font (for icons)
- ripgrep (for searching)

### Features

- **Native LSP**: Uses Neovim 0.11's built-in LSP configuration (no nvim-lspconfig dependency)
- **Mason**: Automatic LSP server, linter, and formatter installation
- **Blink.cmp**: Fast completion engine with LSP, Copilot, and snippet support
- **Treesitter**: Advanced syntax highlighting and code understanding
- **Telescope**: Fuzzy finder for files, buffers, and more (via Snacks.nvim)
- **Modern UI**: Includes lualine, bufferline, and inline diagnostics

### Installation

1. Backup your existing Neovim configuration (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/neonvoidx/nvim.git ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins on first launch.

### Key Bindings

Leader key is set to `<Space>`.

Some important keybindings:
- `<Space>l` - Open Lazy plugin manager
- `<Space>ca` - Code actions
- `<Space>cd` - Show diagnostics
- `gd` - Go to definition
- `K` - Hover documentation

### LSP Servers

The following LSP servers are configured:
- **TypeScript/JavaScript**: vtsls
- **Lua**: lua_ls
- **Python**: basedpyright
- **C/C++**: clangd
- **Go**: gopls
- **Bash**: bashls
- **JSON**: jsonls
- **YAML**: yamlls
- **Docker**: dockerls, docker_compose_language_service
- **CMake**: neocmake
- **Terraform**: terraformls
- **Zig**: zls
- **HTML/CSS**: emmet_language_server
- **Fish**: fish_lsp

LSP servers are managed through Mason and will be automatically installed.

### Structure

```
.
├── init.lua           # Main entry point
├── lua/
│   ├── autocmds.lua   # Autocommands
│   ├── keymaps.lua    # Key mappings
│   ├── opts.lua       # Neovim options
│   ├── util.lua       # Utility functions
│   └── plugins/       # Plugin configurations
└── snippets/          # Custom snippets
```
