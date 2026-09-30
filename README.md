# neonvoid's Neovim config

Neovim configuration built on [nvf](https://github.com/notashelf/nvf) and packaged with Nix. Plugins, language servers and external tools all come from the lock file, so `nix run` produces the same editor on every machine.

## Running it

```bash
nix run github:neonvoidx/nvim     # run
nix build github:neonvoidx/nvim   # build
```

As a flake input:

```nix
{
  inputs.nvim.url = "github:neonvoidx/nvim";
}
```

From a clone:

```bash
git clone git@github.com:neonvoidx/nvim.git ~/nvim
nix run ~/nvim
```

The flake exposes a single output, `packages.default`. It is a `nix-wrapper-modules` wrapped Neovim and builds for `x86_64-linux`, `aarch64-linux`, `x86_64-darwin` and `aarch64-darwin`.

## Requirements

- Nix with flakes enabled
- A patched Nerd Font, for the devicons
- `tmux`, only if you want the split navigation to cross tmux panes

Everything else (yazi, lazygit, gh, ripgrep, fd, cargo, rustc, clangd, arduino tooling, formatters, linters) is added to `PATH` by the flake.

## Layout

```
flake.nix      inputs, the hmts-nvim overlay, userPlugins, packages.default
config/
  default.nix  imports the core modules and every file in plugins/
  options.nix  vim options
  keymaps.nix  global keymaps
  autocmds.nix autocommands
plugins/       one file per feature area
snippets/      nvim-scissors snippets (lua, nix, rust, typescript, package.json)
stylua.toml    Lua formatting, used for snippet edits
```

`config/default.nix` is the only file to edit when adding or removing a feature area.

## Plugins

Most plugins come from nixpkgs. Four are built from flake inputs in `flake.nix`: eldritch, resolved, milli and the milli splash data.

### Appearance

- [eldritch.nvim](https://github.com/eldritch-theme/eldritch.nvim): colorscheme, transparent background, matching lualine palette (`colorscheme.nix`, `lualine.nix`)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim): statusline, with inline git blame and Overseer task components
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim): buffer tabline
- [snacks.nvim](https://github.com/folke/snacks.nvim): dashboard, pickers, notifier, terminal, indent guides, zen mode, file rename, lazygit launcher
- [milli.nvim](https://github.com/Amansingh-afk/milli.nvim): retro splash animation used as the dashboard header, plus the starfield idle screensaver
- [noice.nvim](https://github.com/folke/noice.nvim): cmdline, messages, LSP progress
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons): file icons
- [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors): inline color swatches
- [tiny-inline-diagnostic.nvim](https://github.com/rachartier/tiny-inline-diagnostic.nvim): inline diagnostics
- [helpview.nvim](https://github.com/OXY2DEV/helpview.nvim): `:help` in a float window
- [which-key.nvim](https://github.com/folke/which-key.nvim): keymap hints, helix preset

### Completion and LSP

- [blink.cmp](https://github.com/Saghen/blink.cmp): completion engine, sources are lsp, path, lazydev, snippets and buffer
- [lazydev.nvim](https://github.com/folke/lazydev.nvim): Neovim Lua API completions
- [lspkind.nvim](https://github.com/rcarriga/nvim-lspkind.lua): icons in LSP pickers
- [trouble.nvim](https://github.com/folke/trouble.nvim): diagnostics list
- [inc-rename.nvim](https://github.com/smjonas/inc-rename.nvim): incremental LSP rename

Enabled servers: `nixd`, `lua-language-server`, `vtsls`, `basedpyright`, `rust-analyzer`, `clangd`, `gopls`, `yaml-language-server`, `zls`, and a hand written `arduino_language_server` entry in `plugins/lsp.nix`. Odin gets treesitter but no LSP, see the comment in that file.

Treesitter uses every grammar from nixpkgs, with [treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) for the sticky header and [treesitter-endwise](https://github.com/RRethy/nvim-treesitter-endwise) for automatic block closing.

### Editing

- [mini.pairs](https://github.com/echasnovski/mini.pairs) and [mini.surround](https://github.com/echasnovski/mini.surround)
- [flash.nvim](https://github.com/folke/flash.nvim): jump, with auto jump on the sole match
- [vim-illuminate](https://github.com/RRethy/vim-illuminate): highlight the word under the cursor
- [numb.nvim](https://github.com/nacro90/numb.nvim): peek line numbers
- [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim)
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim): custom keywords and highlight groups
- [overseer.nvim](https://github.com/stevearc/overseer.nvim): task runner
- [quicker.nvim](https://github.com/stevearc/quicker.nvim): collapse and expand around the quickfix list
- [nvim-scissors](https://github.com/chrisgrieser/nvim-scissors): edit the snippets in `snippets/`
- [persistence.nvim](https://github.com/folke/persistence.nvim): per directory sessions
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo): folding, with a line count in the fold text
- [smart-splits.nvim](https://github.com/smart-splits-nvim/smart-splits.nvim): `<C-h/j/k/l>` between splits and tmux panes, `<C-S-h/j/k/l>` to resize

### Formatting and linting

- [conform.nvim](https://github.com/stevearc/conform.nvim): format on save, with `lsp_format` as a fallback. Toggle with `<leader>cf` globally or `<leader>cF` for the buffer
- [nvim-lint](https://github.com/mfussenegger/nvim-lint): runs on `BufEnter`, `BufWritePost` and `InsertLeave`. Currently wired up for cmake and, when `eslint_d` is on `PATH`, the JavaScript and TypeScript family

### Git

- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim): signs and hunks. Its own keymaps are unbound in favour of the ones below
- [diffview.nvim](https://github.com/sindrets/diffview.nvim): diff and merge, diff3 layout
- [git-blame.nvim](https://github.com/lewis6991/git-blame.nvim): inline blame in the statusline

### Files, search and documents

- [yazi.nvim](https://github.com/mikavilpas/yazi.nvim): file manager. netrw is disabled in favour of it
- [yanky.nvim](https://github.com/gbprod/yanky.nvim): yank and paste ring, stored in shada
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim): browser preview

### Issue tracking

- [resolved.nvim](https://github.com/noamsto/resolved.nvim): finds GitHub issue and PR URLs in comments and shows their state inline, so a workaround next to a closed issue gets noticed. Treesitter picks the comment nodes per filetype, keywords such as `TODO` or `workaround` mark a closed reference as stale, and `<leader>gpi` opens a picker over everything referenced in the workspace. The keyword list is aligned with the todo-comments set in `plugins/editing.nix`

### Nix

- [hmts.nvim](https://github.com/calops/hmts.nvim): treesitter injections for languages inlined in Home Manager `nix` files

## Tools on PATH

Added by `extraPackages` in this config: yazi, lazygit, gh, ripgrep, fd, cargo, rustc, clang-tools, arduino-language-server, arduino-cli, stylua, nixfmt, black, isort, prettier, prettierd, eslint_d, markdownlint-cli2. nvf adds a few more per language, including rustfmt, gofmt, clang-format and odinfmt.

Two things need a one time setup outside this repo:

- `gh auth login`, for resolved.nvim. It has no unauthenticated fallback, and it stays disabled until the auth check passes. `:checkhealth resolved` reports the state.
- `arduino-cli config init && arduino-cli core install arduino:avr`. The per project board goes in `.vscode/arduino.json`.

## Keymaps

A small selection. Everything else shows up under which-key after the leader.

| Key | Action |
|---|---|
| `<leader><space>` | smart file picker |
| `<leader>/` | grep, or grep the visual selection |
| `<leader>gg` | lazygit |
| `gd` `gD` `gr` `gI` `gy` | LSP definition, declaration, references, implementation, type definition |
| `<leader>ca` `<leader>cA` | code action for the line or the buffer |
| `<leader>cr` | incremental rename |
| `<leader>xx` | diagnostics for this buffer |
| `<leader>qs` `<leader>qS` `<leader>ql` | restore, select or reopen the last session |
| `<leader>e` `<leader>E` | yazi for the current file or directory |
| `<leader>gh` | hunk group: blame, diff, stage, reset, preview |
| `<leader>gpi` | picker over every issue and PR referenced in the workspace |
| `<leader>gpR` `<leader>gpt` `<leader>gpc` | refresh, toggle, clear cache |
| `<leader>u…` | toggle spell, wrap, line numbers, diagnostics, treesitter, indent, dim, inlay hints, zen |
| `<C-h/j/k/l>` | move between splits and tmux panes |
| `<C-S-h/j/k/l>` | resize the split |
| `<A-j>` `<A-k>` | move the current line or selection down or up |

Milli also ships a few commands: `:MilliPreview <name>` opens a splash full screen, `:MilliShader <name>` plays one of the bundled shaders, and `:MilliScreensaver` shows the screensaver without waiting for the idle timer.

## The dashboard splash and the idle screensaver

The dashboard header animates the `retrocircle` splash. That splash does not ship with milli.nvim, it comes from the community registry at [milli-splashes](https://github.com/Amansingh-afk/milli-splashes), and milli normally downloads it on first run with `:MilliInstall retrocircle`. That step needs `curl` and network access, so a fresh machine without it would fail to start.

To avoid that, the splash is fetched at build time instead. `flake.nix` keeps a list:

```nix
milliSplashes = [ "retrocircle" ];
```

Each name is copied from the pinned `milli-splashes` flake input into `lua/milli/splashes/`, which puts it on the runtimepath where milli looks for its bundled splashes. Adding another name to the list is the whole procedure for switching or adding splashes. No runtime download, no first run step, and the version is pinned by `flake.lock`.

The screensaver is the `starfield` shader, a procedural warp effect that needs no data files. `plugins/snacks.nix` starts it with:

```lua
require("milli").screensaver({ shader = "starfield", after = 300, bg = "#000000" })
```

`after` is seconds without a typed key, so 300 is five minutes. It draws into a full screen float, so buffer, cursor, layout and mode are left as they were. Any keypress dismisses it and the key is swallowed, so nothing leaks into the buffer. It stays out of the way in the command line, in visual or terminal mode, and while a macro is recording.

## License

Personal configuration. Use and modify it however you like.
