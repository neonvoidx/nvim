{
  description = "neonvoid's Neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers.inputs.nixpkgs.follows = "nixpkgs";

    # Freshest lze + lzextras (same pattern as the template)
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };

    # Plugins NOT in nixpkgs
    plugins-eldritch-nvim = {
      url = "github:eldritch-theme/eldritch.nvim/0415fa72c348e814a7a6cc9405593a4f812fe12f";
      flake = false;
    };
    plugins-vim-kitty = {
      url = "github:fladson/vim-kitty";
      flake = false;
    };
    plugins-git-scripts-nvim = {
      url = "github:declancm/git-scripts.nvim";
      flake = false;
    };
    plugins-resolved-nvim = {
      url = "github:noamsto/resolved.nvim";
      flake = false;
    };
    plugins-markdown-toc-nvim = {
      url = "github:hedyhli/markdown-toc.nvim";
      flake = false;
    };
    plugins-presenting-nvim = {
      url = "github:sotte/presenting.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      module = nixpkgs.lib.modules.importApply ./module.nix inputs;
      wrapper = wrappers.lib.evalModule module;
    in
    {
      overlays = {
        neovim = final: prev: { neovim = wrapper.config.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      wrapperModules = {
        neovim = module;
        default = self.wrapperModules.neovim;
      };
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          neovim = wrapper.config.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
        }
      );
      nixosModules = {
        default = self.nixosModules.neovim;
        neovim = wrappers.lib.mkInstallModule {
          name = "neovim";
          value = module;
        };
      };
      homeModules = {
        default = self.homeModules.neovim;
        neovim = wrappers.lib.mkInstallModule {
          name = "neovim";
          value = module;
          loc = [
            "home"
            "packages"
          ];
        };
      };
    };
}
