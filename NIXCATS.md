# nixCats Integration Guide

This Neovim configuration now supports both traditional lazy.nvim installation and Nix-managed builds using [nixCats](https://github.com/BirdeeHub/nixCats-nvim).

## What Changed?

1. **Added nixCatsUtils** (`lua/nixCatsUtils/`)
   - Utilities to detect if running under Nix
   - Lazy.nvim wrapper that works with both Nix and non-Nix setups

2. **Updated lazy.lua** (`lua/config/lazy.lua`)
   - Now uses nixCatsUtils wrapper
   - Automatically adapts based on whether Nix is being used

3. **Conditionally disabled Mason** (`lua/plugins/lsp.lua`)
   - Mason and mason-lspconfig are disabled when using Nix
   - Nix manages LSPs, formatters, and linters instead

4. **Updated Treesitter** (`lua/plugins/treesitter.lua`)
   - Build steps disabled when using Nix (Nix handles compilation)

5. **Added flake.nix**
   - Defines all dependencies and plugins
   - Provides NixOS and Home Manager modules

## Using Without Nix

Everything works exactly as before! Just clone and run nvim:

```bash
git clone <this-repo> ~/.config/nvim
nvim
```

Mason will automatically install LSPs and other tools.

## Using With Nix

### First Time Setup

If you're building from a fresh clone, regenerate the lock file:

```bash
nix flake lock
```

This will update `flake.lock` with the latest versions of all dependencies.

### Option 1: Build and Run

```bash
nix build .
./result/bin/nvim
```

### Option 2: Development Shell

```bash
nix develop
nvim
```

### Option 3: NixOS Configuration

Add to your `flake.nix`:

```nix
{
  inputs.nvim.url = "github:neonvoidx/nvim";
  
  # ... in your configuration
  nixCats.nvim.enable = true;
}
```

### Option 4: Home Manager

```nix
{
  inputs.nvim.url = "github:neonvoidx/nvim";
  
  # ... in your home configuration
  nixCats.nvim.enable = true;
}
```

## Customizing Nix Build

Edit `flake.nix` to:
- Add/remove LSPs in `lspsAndRuntimeDeps.general`
- Add/remove plugins in `startupPlugins.general`
- Modify package settings
- Add custom categories

After changes, run:
```bash
nix flake lock  # Update lock file
nix build       # Build the package
```

## Benefits of Nix

- **Reproducible**: Identical setup on every machine
- **Declarative**: All dependencies in one place
- **Fast**: No plugin downloads at runtime
- **Reliable**: Version-locked dependencies
- **Integrated**: Works with NixOS/Home Manager

## Files Added/Modified

- `flake.nix` - Nix package definition
- `flake.lock` - Dependency lock file
- `lua/nixCatsUtils/init.lua` - nixCats utilities
- `lua/nixCatsUtils/lazyCat.lua` - lazy.nvim wrapper
- `lua/config/lazy.lua` - Updated to use wrapper
- `lua/plugins/lsp.lua` - Conditionally disable Mason
- `lua/plugins/treesitter.lua` - Conditionally disable builds
- `.gitignore` - Ignore Nix build outputs

## Learn More

- [nixCats Documentation](https://nixcats.org)
- [nixCats Lua Utils](https://nixcats.org/nixCats_luaUtils.html)
- [nixCats Templates](https://nixcats.org/nixCats_templates.html)
