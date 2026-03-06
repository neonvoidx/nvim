# Copilot Instructions

## Build & Run

```bash
nix build .#          # Build the wrapped neovim derivation
nix run .#            # Run neovim directly from the flake
nix run .# -- --headless -c "lua print('OK')" -c "q"  # Headless smoke test
nix flake update      # Update all flake inputs (plugins, nixpkgs)
```

Formatting: `stylua lua/` (120-column, 2-space indent, double quotes — see `stylua.toml`).

## Architecture

This is a **dual-mode Neovim config**: it works both under Nix (via `nix-wrapper-modules`) and on macOS/Linux without Nix.

```
init.lua          → nix/non-nix detection, vim.pack.add bootstrap, lze setup
flake.nix         → flake inputs, overlay, package output
module.nix        → nix-wrapper-modules spec: plugin lists, LSPs, formatters in PATH
lua/config/
  lze.lua         → loads all plugin modules via lze.load()
  opts.lua        → vim options
  keymaps.lua     → global keymaps
  autocmds.lua    → autocommands
lua/plugins/      → one file per feature area, each returns an lze spec table
snippets/         → custom VSCode-format snippet files
```

### Plugin loading pipeline

1. **Nix path**: nix-wrapper-modules places plugins in `nvim-packdir/pack/myNeovimPackages/{start,opt}/`. All plugins land in `opt` unless the spec has `lazy = false` at the Nix level.
2. **Non-nix path**: `vim.pack.add({urls}, { load = function() end, confirm = false })` downloads all plugins and marks them optional; then `lze` drives loading.
3. `lua/config/lze.lua` calls `lze.load(specs)` for each module in `lua/plugins/`.

### lze spec format (replaces lazy.nvim)

| lazy.nvim | lze equivalent |
|---|---|
| `[1] = "owner/plugin"` | `[1] = "plugin-packdir-name"` (pname, not GitHub path) |
| `config = function(_, opts)` | `after = function(plugin)` |
| `init = function()` | `beforeAll = function(plugin)` — runs **before** packadd, cannot `require` the plugin |
| `opts = {}` | inline table inside `after` |
| `dependencies = {}` | removed — all deps listed in `module.nix` specs |
| `event = "VeryLazy"` | `event = "User VeryLazy"` |

`User VeryLazy` is emitted manually in `init.lua` via a `UIEnter` autocmd (lazy.nvim built-in, not available in lze).

## Key Conventions

### Plugin packdir names
The `[1]` field in an lze spec must match the **pname** (the directory name under `opt/` or `start/`), not the GitHub repo name. To verify:
```bash
ls /nix/store/*-neovim-unwrapped-*/nvim-packdir/pack/myNeovimPackages/opt/
```
nixpkgs attrs map to pnames: `snacks-nvim` → `snacks.nvim`, `which-key-nvim` → `which-key.nvim`. Plugins built from flake inputs via `mkPlugin "name" src` get exactly `"name"` as their pname.

### Explicit packadd for opt dependencies
All plugins are in `opt`. When plugin A's `after` function needs plugin B (a dependency), explicitly `packadd` B first:
```lua
after = function()
  vim.cmd.packadd("nui.nvim")      -- dependency
  vim.cmd.packadd("blink-copilot") -- another dep
  require("noice").setup(...)
end
```
Already applied to: `nui.nvim`, `promise-async`, `SchemaStore.nvim`, `resolved-nvim`, `plenary.nvim`, `blink-copilot`, `lazydev.nvim`, `nvim-web-devicons`, `nvim-treesitter-endwise`.

### Mason is disabled on Nix
`vim.g.mason_disabled = nixInfo.isNix` is set in `init.lua`. `lua/plugins/mason.lua` returns `{}` early when this is true. LSPs and formatters come from `module.nix` `extraPackages` on Nix.

### Adding a new plugin

**On Nix**: add it to the appropriate `config.specs.*` block in `module.nix` (use `pkgs.vimPlugins.attr-name` if in nixpkgs, or add a flake input with `plugins-` prefix and reference via `config.nvim-lib.neovimPlugins.name`). If it needs a binary tool, add to `extraPackages`.

**Non-nix**: add its GitHub URL to the `vim.pack.add({...})` list in `init.lua`.

**Both**: create or update an lze spec in `lua/plugins/<feature>.lua` and add the module name to `lua/config/lze.lua`.

### Plugins not in nixpkgs
Six plugins come from flake inputs (prefix `plugins-` in `flake.nix`):
- `eldritch-nvim`, `vim-kitty`, `git-scripts-nvim`, `resolved-nvim`, `markdown-toc-nvim`, `presenting-nvim`

`eldritch-theme` is pinned to a specific commit SHA due to their org's PAT token restrictions.

### LSP configuration
Uses `vim.lsp.config()` + `vim.lsp.enable()` (nvim 0.11 API) — **not** `lspconfig.server.setup()`. See `lua/plugins/lsp.lua`. Rust uses `rustaceanvim` (`vim.g.rustaceanvim`), C/C++ uses `clangd_extensions.nvim`.

### `beforeAll` limitation
`beforeAll` in lze fires before `packadd` — the plugin itself is not yet loaded. Only use it to register autocmds or set globals that don't require the plugin (e.g., `vim.g.rustaceanvim = {}`). The `snacks.nvim` VeryLazy autocmd (toggle mappings, debug globals) lives in `beforeAll` because the callback runs later when VeryLazy fires and snacks is already loaded.

### Global `nixInfo`
`_G.nixInfo.isNix` — true when running under nix-wrapper-modules. `_G.nixInfo.lze` — the lze table with lzextras methods merged in via `setmetatable`. `_G.Snacks` — set at end of snacks.nvim `after`.
