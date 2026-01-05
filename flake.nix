# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
# Adapted for neonvoidx/nvim configuration

{
  description = "Neonvoid's nixCats-powered neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # NOTE: If you need plugins not in nixpkgs, add them here with "plugins-<name>"
    # Example:
    # plugins-someplugin = {
    #   url = "github:author/repo";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = ./.;
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    
    extra_pkg_config = {
      allowUnfree = true;
    };

    dependencyOverlays = [
      # Standard plugin overlay from inputs
      (utils.standardPluginOverlay inputs)
    ];

    # Category definitions - organize dependencies and plugins
    categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
      
      # LSPs and runtime dependencies
      lspsAndRuntimeDeps = with pkgs; {
        general = [
          # Core tools
          universal-ctags
          ripgrep
          fd
          tree-sitter
          
          # LSPs
          lua-language-server
          nil # or nixd
          stylua
          nodePackages.bash-language-server
          nodePackages.vscode-langservers-extracted # json, html, css, eslint
          nodePackages.typescript-language-server
          gopls
          basedpyright
          yaml-language-server
          dockerfile-language-server-nodejs
          terraform-ls
          clang-tools
          zls
          nodePackages.emmet-ls
          
          # Formatters
          prettierd
          black
          isort
          nodePackages.markdownlint-cli2
          nixpkgs-fmt
          
          # Linters
          nodePackages.eslint_d
          pylint
          yamllint
          checkmake
          terraform
        ];
      };

      # Startup plugins - loaded at startup
      startupPlugins = with pkgs.vimPlugins; {
        general = [
          # Plugin manager
          lazy-nvim
          
          # Core dependencies
          plenary-nvim
          nvim-web-devicons
          nui-nvim
          
          # LSP & Completion
          nvim-lspconfig
          lazydev-nvim
          lspkind-nvim
          clangd_extensions-nvim
          rustaceanvim
          vim-illuminate
          
          # Completion - blink.cmp
          # Note: blink.cmp might need to be built, we'll handle it via inputs
          copilot-lua
          
          # Treesitter
          (nvim-treesitter.withAllGrammars)
          nvim-treesitter-context
          nvim-treesitter-endwise
          nvim-ts-context-commentstring
          
          # UI
          which-key-nvim
          noice-nvim
          bufferline-nvim
          lualine-nvim
          nvim-highlight-colors
          tiny-inline-diagnostic-nvim
          
          # Themes
          eldritch-nvim
          catppuccin-nvim
          dracula-nvim
          nightfox-nvim
          onedark-nvim
          tokyonight-nvim
          
          # Navigation
          flash-nvim
          yazi-nvim
          numb-nvim
          
          # Editing
          mini-nvim # includes mini.pairs and mini.surround
          inc-rename-nvim
          nvim-scissors
          friendly-snippets
          yanky-nvim
          
          # Git
          gitsigns-nvim
          git-blame-nvim
          diffview-nvim
          
          # Formatting & Linting
          conform-nvim
          nvim-lint
          
          # Utilities
          snacks-nvim
          overseer-nvim
          persistence-nvim
          todo-comments-nvim
          trouble-nvim
          nvim-ufo
          promise-async
          helpview-nvim
          guess-indent-nvim
          
          # Markdown
          markdown-preview-nvim
          render-markdown-nvim
          
          # Kitty
          vim-kitty
          vim-kitty-navigator
          kitty-scrollback-nvim
          
          # Quickfix
          quicker-nvim
        ];
      };

      # Optional plugins - not loaded automatically
      optionalPlugins = {};

      # Shared libraries
      sharedLibraries = {
        general = with pkgs; [
          # Add shared libraries if needed
        ];
      };

      # Environment variables
      environmentVariables = {
        general = {
          # Add environment variables if needed
        };
      };

      extraWrapperArgs = {
        general = [
          # Add wrapper args if needed
        ];
      };

      # Python packages
      python3.libraries = {
        general = (_:[]);
      };
      
      # Lua packages
      extraLuaPackages = {
        general = [ (_:[]) ];
      };
    };

    # Package definitions
    packageDefinitions = {
      nvim = { pkgs, name, ... }: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          aliases = [ "vim" "vi" ];
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        
        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;
          
          # Pass info to lua
          have_nerd_font = true;
        };
      };
    };
    
    defaultPackageName = "nvim";
  in
  
  forEachSystem (system: let
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages = utils.mkAllWithDefault defaultPackage;

    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
          echo "nixCats neovim dev shell"
          echo "Run 'nvim' to start"
        '';
      };
    };

  }) // (let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });
}
