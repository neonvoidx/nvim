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
    milli-nvim = {
      url = "github:Amansingh-afk/milli.nvim";
      flake = false;
    };
    # Community splash registry. Only used at build time, to bake the
    # splashes listed in `milliSplashes` into the runtimepath.
    milli-splashes = {
      url = "github:Amansingh-afk/milli-splashes";
      flake = false;
    };
    # nvf pins smart-splits v2.1.0 via npins; backend-kitty needs v3.
    smart-splits-nvim = {
      url = "github:smart-splits-nvim/smart-splits.nvim?tag=v3.0.0";
      flake = false;
    };
    backend-kitty = {
      url = "github:smart-splits-nvim/backend-kitty";
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
          # Community splashes to bake into the runtimepath. Add a name here to
          # make it usable as `splash = "<name>"` without any runtime install.
          milliSplashes = [ "retrocircle" ];
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              # https://github.com/NixOS/nixpkgs/issues/535580
              permittedInsecurePackages = [
                "pnpm-10.34.0"
              ];
            };
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
            ];
          };
          # Vendored splash data, placed at lua/milli/splashes/ so milli.nvim
          # finds it on the runtimepath exactly like a bundled splash.
          milliSplashesSrc = pkgs.runCommand "milli-splashes" { } (
            ''
              mkdir -p "$out/lua/milli/splashes"
            ''
            + pkgs.lib.concatMapStringsSep "\n" (
              splash: ''
                cp ${inputs.milli-splashes}/splashes/${splash}.lua \
                  "$out/lua/milli/splashes/"
              ''
            ) milliSplashes
            + ''
              cp ${inputs.milli-splashes}/LICENSE "$out/LICENSE"
            ''
          );
          userPlugins = {
            eldritch-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "eldritch.nvim";
              src = inputs.eldritch-nvim;
            };
            resolved-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "resolved.nvim";
              src = inputs.resolved-nvim;
            };
            milli-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "milli.nvim";
              src = inputs.milli-nvim;
            };
            # milli.nvim only bundles six splashes. The rest live in the
            # community registry and are normally fetched at runtime with
            # :MilliInstall, which needs curl and network on first launch.
            # Copying the ones we want into the runtimepath here keeps the
            # dashboard working on a fresh machine with no first-run step.
            milli-splashes-nvim = pkgs.vimUtils.buildVimPlugin {
              name = "milli-splashes";
              # src is already an unpacked directory, so skip the archive
              # sniffing that the default unpackPhase would try to do.
              unpackPhase = ''
                cp -r ${milliSplashesSrc}/. .
              '';
              src = milliSplashesSrc;
            };
            # smart-splits v3 (nvf's npins pin is v2.1.0, which predates the
            # backend plugin architecture). pname must match the
            # vim.lazy.plugins attr key.
            smart-splits = pkgs.vimUtils.buildVimPlugin {
              pname = "smart-splits";
              version = "3.0.0";
              src = inputs.smart-splits-nvim;
            };
            smart-splits-backend-kitty = pkgs.vimUtils.buildVimPlugin {
              pname = "smart-splits-backend-kitty";
              version = "unstable-2026-09-24";
              src = inputs.backend-kitty;
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
