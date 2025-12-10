{
  description = "Neonvoid's Neovim configuration using nixvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixvim, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        nixvimLib = nixvim.legacyPackages.${system};
        
        nvim = nixvimLib.makeNixvimWithModule {
          inherit pkgs;
          module = ./config;
        };
      in
      {
        packages = {
          default = nvim;
          nvim = nvim;
        };

        # For Home Manager integration
        nixosModules.default = {
          imports = [ ./config ];
        };

        # Allow running with `nix run`
        apps.default = {
          type = "app";
          program = "${nvim}/bin/nvim";
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = [ nvim ];
          shellHook = ''
            echo "Neovim with nixvim configuration loaded"
            echo "Run 'nvim' to start"
          '';
        };
      }
    );
}
