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
    presenting-nvim = {
      url = "github:sotte/presenting.nvim";
      flake = false;
    };
    milli-nvim = {
      url = "github:Amansingh-afk/milli.nvim";
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
            overlays = [
              # hmts-nvim uses the old treesitter predicate API where match[id] was a single
              # TSNode; nvim 0.11+ changed it to always be a list. Unwrap the first element.
              (final: prev: {
                vimPlugins = prev.vimPlugins // {
                  hmts-nvim = prev.vimPlugins.hmts-nvim.overrideAttrs (old: {
                    postPatch = (old.postPatch or "") + ''
                      substituteInPlace plugin/hmts.lua \
                        --replace-fail \
                          'local node = match[predicate[2]]:parent()' \
                          'local _n = match[predicate[2]]; local node = (type(_n) == "table" and _n[1] or _n):parent()' \
                        --replace-fail \
                          'local path_node = match[predicate[2]]' \
                          'local _pn = match[predicate[2]]; local path_node = type(_pn) == "table" and _pn[1] or _pn'
                    '';
                  });
                };
              })
              # Pin pnpm to secure versions
              (final: prev: {
                pnpm_10_29_2 = final.pnpm_10;
                pnpm_10_34_0 = final.pnpm_10;
              })
            ];
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
            markdown-toc-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "markdown-toc.nvim";
              src = inputs.markdown-toc-nvim;
            };
            presenting-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "presenting.nvim";
              src = inputs.presenting-nvim;
            };
            milli-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "milli.nvim";
              src = inputs.milli-nvim;
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
