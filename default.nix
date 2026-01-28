# nixCats neovim configuration
{ inputs, ... }:
let
  inherit (inputs.nixCats) utils;
  luaPath = ./.;

  extra_pkg_config = {
    allowUnfree = true;
  };

  dependencyOverlays = [
    (utils.standardPluginOverlay inputs)
  ];
in
{
  categoryDefinitions =
    {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    }@packageDef:
    {

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
          nixd
          stylua
          nodePackages.bash-language-server
          nodePackages.vscode-langservers-extracted # json, html, css, eslint
          nodePackages.typescript-language-server
          gdtoolkit_4
          gopls
          basedpyright
          yaml-language-server
          dockerfile-language-server
          terraform-ls
          clang-tools
          zls

          # Formatters
          prettierd
          black
          isort
          nodePackages.markdownlint-cli2
          nixpkgs-fmt
          nixfmt

          # Linters
          nodePackages.eslint_d
          pylint
          yamllint
          checkmake
          terraform
        ];
      };

      startupPlugins = with pkgs.vimPlugins; {
        general = [ ];
      };

      optionalPlugins = with pkgs.vimPlugins; {
        general = [
          (nvim-treesitter.withAllGrammars)
          nvim-treesitter-endwise
          (nvim-treesitter-context.overrideAttrs (old: {
            src = pkgs.fetchFromGitHub {
              owner = "nvim-treesitter";
              repo = "nvim-treesitter-context";
              rev = "64dd4cf3f6fd0ab17622c5ce15c91fc539c3f24a";
              hash = "sha256-0dmcpn7l1f4bxvfa4li9sw8k1a5gh0r9zslflb5yrnax1ww71nyw";
            };
          }))
          nvim-ts-context-commentstring
        ];
      };

      sharedLibraries = {
        general = with pkgs; [ ];
      };

      environmentVariables = {
        general = { };
      };

      extraWrapperArgs = {
        general = [ ];
      };

      python3.libraries = {
        general = (_: [ ]);
      };

      extraLuaPackages = {
        general = [ (_: [ ]) ];
      };
    };

  packageDefinitions = {
    nvim =
      { pkgs, name, ... }:
      {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = true;
          aliases = [
            "vim"
            "vi"
          ];
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };

        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;
          have_nerd_font = true;
        };
      };
  };

  # Export everything needed for the home-manager module
  inherit dependencyOverlays extra_pkg_config luaPath;
  defaultPackageName = "nvim";
}
