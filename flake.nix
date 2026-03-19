{
  description = "neonvoid's Neovim configuration (nvf)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Plugins not packaged in nixpkgs
    eldritch-nvim = {
      url = "github:eldritch-theme/eldritch.nvim/0415fa72c348e814a7a6cc9405593a4f812fe12f";
      flake = false;
    };
    resolved-nvim = {
      url = "github:noamsto/resolved.nvim";
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
          neovimConfig = nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [ ./config ];
            extraSpecialArgs = { inherit inputs pkgs; };
          };
        in
        {
          # Run `nix run .` to start neovim
          packages.default = neovimConfig.neovim;
        };
    };
}
