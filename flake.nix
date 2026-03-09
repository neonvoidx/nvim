{
  description = "neonvoid's Neovim configuration (nixvim)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Plugins not in nixpkgs
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
      nixvim,
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
            config = {
              # Allow only the specific unfree package we need.
              allowUnfreePredicate = pkg:
                builtins.elem (nixpkgs.lib.getName pkg) [
                  "copilot-language-server"
                ];
            };
          };
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit system;
            module = import ./config;
            extraSpecialArgs = {
              inherit inputs;
            };
          };
          nvim = nixvim'.makeNixvimWithModule (nixvimModule // { inherit pkgs; });
        in
        {
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          packages = {
            # Lets you run `nix run .` to start nixvim
            default = nvim;
          };
        };
    };
}
