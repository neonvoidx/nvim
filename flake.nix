{
  description = "Neovim 0.12+ config, with mostly native nvim usage";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      homeManagerModules.default =
        { config, pkgs, ... }:
        {
          programs.neovim = {
            enable = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            defaultEditor = true;
            waylandSupport = true;
            plugins = [
              (pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
            ];
            extraPackages = with pkgs; [
              tree-sitter

              # language servers
              nodejs_24
              basedpyright
              clang-tools
              lua-language-server
              nil
              rust-analyzer
              yaml-language-server
              vtsls

              # lint
              cmake-lint

              # formatters
              eslint_d
              prettierd
              stylua
              isort
              black
              markdownlint-cli2
              markdown-toc
              nixfmt
              rustfmt

              # tools
              fzf
              fd
              cargo
              ripgrep
            ];
          };

          xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nvim-min";
        };

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
            plugins = [
              (pkgs.vimPlugins.nvim-treesitter.withAllGrammars)
            ];
          };
        }
      );
    };
}
