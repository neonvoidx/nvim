# Nixvim Configuration Validation Checklist

This document provides a checklist for validating and testing the nixvim configuration.

## Pre-Build Validation

### 1. Syntax Validation

Check Nix syntax of all files:

```bash
# Check individual files
nix-instantiate --parse config/default.nix
nix-instantiate --parse config/options.nix
nix-instantiate --parse config/keymaps.nix
nix-instantiate --parse config/autocommands.nix
nix-instantiate --parse flake.nix

# Check all plugin files
for f in config/plugins/*.nix; do
  echo "Checking $f..."
  nix-instantiate --parse "$f"
done
```

### 2. Fill SHA256 Hashes

The following plugins need SHA256 hashes filled in:

```bash
# Blink.cmp
nix-prefetch-git https://github.com/saghen/blink.cmp --rev v1.0.0

# Blink-copilot
nix-prefetch-git https://github.com/fang2hou/blink-copilot --rev main

# Snacks.nvim
nix-prefetch-git https://github.com/folke/snacks.nvim --rev main

# Sidekick.nvim
nix-prefetch-git https://github.com/liubianshi/sidekick.nvim --rev main

# Resolved.nvim
nix-prefetch-git https://github.com/noamsto/resolved.nvim --rev main

# Git-scripts.nvim
nix-prefetch-git https://github.com/declancm/git-scripts.nvim --rev main

# Markdown-toc.nvim
nix-prefetch-git https://github.com/hedyhli/markdown-toc.nvim --rev main

# Presenting.nvim
nix-prefetch-git https://github.com/sotte/presenting.nvim --rev main

# Vim-kitty-navigator
nix-prefetch-git https://github.com/knubie/vim-kitty-navigator --rev master

# Kitty-scrollback.nvim
nix-prefetch-git https://github.com/mikesmithgh/kitty-scrollback.nvim --rev main

# Copilot-lsp
nix-prefetch-git https://github.com/copilotlsp-nvim/copilot-lsp --rev main
```

### 3. Update Plugin References

After getting SHA256 hashes, update the following files:
- `config/plugins/completion.nix` - blink.cmp, blink-copilot
- `config/plugins/git.nix` - resolved, git-scripts
- `config/plugins/utilities.nix` - snacks, sidekick
- `config/plugins/markdown.nix` - markdown-toc, presenting
- `config/plugins/kitty.nix` - vim-kitty-navigator, kitty-scrollback
- `config/plugins/ai.nix` - copilot-lsp

## Build Validation

### 1. Test Flake Build

```bash
# Check flake
nix flake check

# Show flake info
nix flake show

# Build the package
nix build .#nvim

# Test run
nix run .#nvim
```

### 2. Test with Home Manager

Add to your Home Manager config:

```nix
{
  programs.nixvim = {
    enable = true;
    imports = [ /path/to/config ];
  };
}
```

Then:

```bash
home-manager build
home-manager switch --show-trace
```

### 3. Test with NixOS

Add to your NixOS config:

```nix
{
  programs.nixvim = {
    enable = true;
    imports = [ /path/to/config ];
  };
}
```

Then:

```bash
nixos-rebuild build --show-trace
nixos-rebuild test
```

## Runtime Validation

### 1. Launch Tests

```bash
# Launch Neovim
nvim

# Check for errors
:checkhealth

# Check plugin loading
:Lazy
:Mason
:LspInfo
```

### 2. Plugin Functionality

Test each major plugin category:

#### LSP
- [ ] Open a TypeScript/JavaScript file
- [ ] Check LSP attaches (`:LspInfo`)
- [ ] Test completion works
- [ ] Test go-to-definition (`gd`)
- [ ] Test hover (`K`)
- [ ] Test code actions (`<space>ca`)
- [ ] Test diagnostics appear

#### Completion
- [ ] Type in insert mode
- [ ] Verify completion menu appears
- [ ] Test Tab to accept
- [ ] Test Copilot suggestions
- [ ] Test snippet expansion

#### Treesitter
- [ ] Open various file types
- [ ] Verify syntax highlighting works
- [ ] Test treesitter context (sticky header)
- [ ] Check `:TSUpdate` and `:TSInstall`

#### UI
- [ ] Check statusline displays correctly
- [ ] Check bufferline shows buffers
- [ ] Test which-key pops up (`<space>`)
- [ ] Test noice enhanced UI

#### Editing
- [ ] Test auto-pairs (type `(` or `{`)
- [ ] Test surround operations
- [ ] Test flash motion (`s`)
- [ ] Test yanky (paste and cycle with `<c-p>`)
- [ ] Test folding (`zc`, `zo`, `zR`, `zM`)

#### Git
- [ ] Open a git repository file
- [ ] Check gitsigns appear in sign column
- [ ] Test git blame (`<leader>gb`)
- [ ] Test diffview (`<leader>gv`)
- [ ] Test staging hunks (`<leader>gs`)

#### Utilities
- [ ] Test yazi file manager (`<leader>e`)
- [ ] Test overseer (`<leader>ot`)
- [ ] Test session restore (`<leader>qs`)

#### Markdown
- [ ] Open a markdown file
- [ ] Test markdown preview (`<leader>mp`)
- [ ] Test render markdown (`<leader>mr`)
- [ ] Check TOC generation (`<leader>mt`)

#### Formatting
- [ ] Open various file types
- [ ] Test format on save
- [ ] Test manual format (`<leader>cf`)
- [ ] Check linters run

#### AI
- [ ] Test Copilot (`<tab>` for suggestions)
- [ ] Test Copilot panel (`<leader>ac`)
- [ ] Test Sidekick (`<leader>aa`)

### 3. Keybindings

Test common keybindings:

#### General
- [ ] `<space>` - Which-key popup
- [ ] `<C-s>` - Save file
- [ ] `<C-q>` - Save and quit
- [ ] `jj` / `kk` - Exit insert mode

#### Navigation
- [ ] `<C-h/j/k/l>` - Window/Kitty navigation
- [ ] `<C-Up/Down/Left/Right>` - Resize windows
- [ ] `<A-j/k>` - Move lines

#### Window Management
- [ ] `<leader>w|` - Vertical split
- [ ] `<leader>w-` - Horizontal split
- [ ] `<leader>wd` - Close window

#### Search
- [ ] `n/N` - Next/prev search result
- [ ] `<esc>` - Clear search highlight

### 4. Error Checking

```bash
# Check for Lua errors
:messages

# Check treesitter
:checkhealth nvim-treesitter

# Check LSP
:checkhealth lsp

# Check plugins
:checkhealth lazy
```

## Common Issues & Fixes

### Issue: Plugin not loading
**Fix**: Check if plugin is in `extraPlugins` and SHA256 is filled

### Issue: LSP not attaching
**Fix**: 
1. Check `:LspInfo`
2. Run `:Mason` and install server
3. Check `config/plugins/lsp.nix` server config

### Issue: Completion not working
**Fix**:
1. Check blink.cmp is loaded
2. Verify LSP is attached
3. Check `config/plugins/completion.nix`

### Issue: Nix evaluation error
**Fix**:
1. Run with `--show-trace` flag
2. Check syntax in reported file
3. Verify all imports exist

### Issue: Missing dependencies
**Fix**: Check that pkgs are available in extraPlugins

## Documentation References

- [config/README.md](config/README.md) - Configuration details
- [NIXVIM.md](NIXVIM.md) - Usage guide
- [PORT_SUMMARY.md](PORT_SUMMARY.md) - Port overview
- [Nixvim Docs](https://nix-community.github.io/nixvim/)
- [Nixvim Options](https://nix-community.github.io/nixvim/search/)

## Completion Criteria

Configuration is validated when:

- [ ] All Nix files parse without errors
- [ ] All SHA256 hashes are filled
- [ ] Flake builds successfully
- [ ] Neovim launches without errors
- [ ] `:checkhealth` shows no critical issues
- [ ] LSP works for at least one language
- [ ] Completion works
- [ ] Basic keybindings work
- [ ] Major plugins load correctly
- [ ] UI displays properly

## Reporting Issues

If you encounter issues:

1. Check the troubleshooting section above
2. Review error messages with `:messages`
3. Run `:checkhealth` and review results
4. Check Nix build output with `--show-trace`
5. Open an issue with:
   - Error message
   - Steps to reproduce
   - Output of `:checkhealth`
   - Nix version (`nix --version`)
   - NixOS/Home Manager version (if applicable)
