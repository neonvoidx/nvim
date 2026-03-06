inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  # Load this repo as the config directory
  config.settings.config_directory = ./.;

  # Plugin builder for flake inputs (plugins-* prefix)
  options.nvim-lib.neovimPlugins = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf wlib.types.stringable;
    default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
  };

  options.nvim-lib.pluginsFromPrefix = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
    default =
      prefix: srcs:
      lib.pipe srcs [
        builtins.attrNames
        (builtins.filter (s: lib.hasPrefix prefix s))
        (map (
          input:
          let
            name = lib.removePrefix prefix input;
          in
          {
            inherit name;
            value = config.nvim-lib.mkPlugin name srcs.${input};
          }
        ))
        builtins.listToAttrs
      ];
  };

  # Signal to lua that we are running under nix
  config.settings.mason_disabled = true;

  # Expose per-spec enable state to lua
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };

  # extraPackages field on each spec, collected into the wrapper PATH
  config.specMods =
    { ... }:
    {
      options.extraPackages = lib.mkOption {
        type = lib.types.listOf wlib.types.stringable;
        default = [ ];
      };
    };
  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];

  # ── lze + lzextras (from flake inputs for latest version) ──────────────
  config.specs.lze = [
    config.nvim-lib.neovimPlugins.lze
    config.nvim-lib.neovimPlugins.lzextras
  ];

  # ── Colorschemes ────────────────────────────────────────────────────────
  config.specs.themes = {
    lazy = true;
    data = with pkgs.vimPlugins; [
      # Primary theme (from flake input, not in nixpkgs)
      config.nvim-lib.neovimPlugins.eldritch-nvim
      # Alternates
      catppuccin-nvim
      tokyonight-nvim
      dracula-nvim
      onedark-nvim
      nightfox-nvim
    ];
  };

  # ── Core UI ─────────────────────────────────────────────────────────────
  config.specs.core-ui = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      snacks-nvim
      which-key-nvim
      noice-nvim
      nui-nvim
      lualine-nvim
      bufferline-nvim
      nvim-web-devicons
      flash-nvim
      todo-comments-nvim
      nvim-highlight-colors
      guess-indent-nvim
      numb-nvim
    ];
  };

  # ── Completion ──────────────────────────────────────────────────────────
  config.specs.completion = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      blink-cmp
      blink-copilot
      friendly-snippets
      nvim-web-devicons
    ];
  };

  # ── LSP ─────────────────────────────────────────────────────────────────
  config.specs.lsp = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-lspconfig
      vim-illuminate
      trouble-nvim
      lazydev-nvim
      rustaceanvim
      clangd_extensions-nvim
      tiny-inline-diagnostic-nvim
      lspkind-nvim
      inc-rename-nvim
      copilot-lsp
      copilot-lua
      SchemaStore-nvim
    ];
    extraPackages = with pkgs; [
      # LSP servers
      lua-language-server
      gopls
      basedpyright
      clang-tools
      bash-language-server
      vscode-langservers-extracted
      yaml-language-server
      docker-compose-language-service
      dockerfile-language-server
      neocmakelsp
      terraform-ls
      zls
      emmet-language-server
      fish-lsp
      typos-lsp
      vtsls
      nil
    ];
  };

  # ── Treesitter ──────────────────────────────────────────────────────────
  config.specs.treesitter = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-endwise
      nvim-ts-context-commentstring
      nvim-treesitter-context
    ];
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };

  # ── Format + Lint ───────────────────────────────────────────────────────
  config.specs.format-lint = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      conform-nvim
      nvim-lint
    ];
    extraPackages = with pkgs; [
      stylua
      isort
      black
      prettierd
      markdownlint-cli2
      kdlfmt
      pylint
      checkmake
      yamllint
      cmake-format
      mermaid-cli
      nodePackages.eslint
    ];
  };

  # ── Git ─────────────────────────────────────────────────────────────────
  config.specs.git = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      gitsigns-nvim
      git-blame-nvim
      diffview-nvim
      config.nvim-lib.neovimPlugins.git-scripts-nvim
      config.nvim-lib.neovimPlugins.resolved-nvim
      plenary-nvim
    ];
    extraPackages = with pkgs; [
      lazygit
      git
    ];
  };

  # ── Folds ───────────────────────────────────────────────────────────────
  config.specs.folds = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-ufo
      promise-async
    ];
  };

  # ── Snippets ────────────────────────────────────────────────────────────
  config.specs.snippets = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-scissors
      friendly-snippets
    ];
  };

  # ── AI ──────────────────────────────────────────────────────────────────
  config.specs.ai = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      sidekick-nvim
    ];
  };

  # ── Session ─────────────────────────────────────────────────────────────
  config.specs.session = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      persistence-nvim
    ];
  };

  # ── Editing helpers ─────────────────────────────────────────────────────
  config.specs.editing = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      mini-pairs
      mini-surround
      yanky-nvim
      overseer-nvim
      quicker-nvim
    ];
  };

  # ── Markdown + Docs ─────────────────────────────────────────────────────
  config.specs.markdown-docs = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      markdown-preview-nvim
      render-markdown-nvim
      obsidian-nvim
      config.nvim-lib.neovimPlugins.markdown-toc-nvim
      config.nvim-lib.neovimPlugins.presenting-nvim
      helpview-nvim
    ];
  };

  # ── File navigation ─────────────────────────────────────────────────────
  config.specs.navigation = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      yazi-nvim
      plenary-nvim
    ];
    extraPackages = with pkgs; [
      yazi
      fd
      ripgrep
    ];
  };

  # ── Kitty integration ───────────────────────────────────────────────────
  config.specs.kitty = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      vim-kitty-navigator
      kitty-scrollback-nvim
      config.nvim-lib.neovimPlugins.vim-kitty
    ];
  };

  # ── Nix integration ─────────────────────────────────────────────────────
  config.specs.nix-integration = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      hmts-nvim
    ];
    extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };

  # ── Mason (available from nixpkgs but disabled on nix) ──────────────────
  # We include the plugins so they're available, but mason_disabled=true
  # means the lua config skips the setup entirely on nix.
  config.specs.mason = {
    after = [ "lze" ];
    lazy = true;
    data = with pkgs.vimPlugins; [
      mason-nvim
      mason-lspconfig-nvim
      mason-tool-installer-nvim
    ];
  };
}
