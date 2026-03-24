{
  description = "neonvoid's Neovim configuration (nvf)";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://cache.garnix.io"
      "https://nix-community.cachix.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Plugins not packaged in nixpkgs
    eldritch-nvim = {
      url = "github:eldritch-theme/eldritch.nvim";
      flake = false;
    };
    resolved-nvim = {
      url = "github:noamsto/resolved.nvim";
      flake = false;
    };
    markdown-toc-nvim = {
      url = "github:hedyhli/markdown-toc.nvim";
      flake = false;
    };
    vim-kitty-navigator = {
      url = "github:knubie/vim-kitty-navigator";
      flake = false;
    };
  };

  outputs =
    {
      nvf,
      flake-parts,
      nixpkgs,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          userPlugins = {
            eldritch-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "eldritch.nvim";
              src = inputs.eldritch-nvim;
            };
            resolved-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "resolved.nvim";
              src = inputs.resolved-nvim;
            };
            vim-kitty-navigator = pkgs.vimUtils.buildVimPlugin {
              name = "vim-kitty-navigator";
              src = inputs.vim-kitty-navigator;
            };
            markdown-toc-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "markdown-toc.nvim";
              src = inputs.markdown-toc-nvim;
            };
          };
          neovimConfig = nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [ ./config ];
            extraSpecialArgs = { inherit userPlugins; };
          };
        in
        {
          # Run `nix run .` to start neovim
          packages.default = neovimConfig.neovim;
        };
    };
}
