{
  description = "nvim-min: minimal Neovim 0.13 config — vim.pack manages plugins, Nix provides the environment";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CXWu8KFDWJjkLh9eU="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim = {
      url = "github:neovim/neovim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      neovim,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = perSystem (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          lib = pkgs.lib;

          # Neovim 0.13 (master): nixpkgs unstable only carries 0.12.x.
          neovim013 = pkgs.neovim-unwrapped.overrideAttrs (old: {
            src = neovim;
            version = "0.13.0-nightly";
            # The nixpkgs `system_rplugin_manifest.patch` targets old internals and
            # is only needed for nix-managed remote plugins; vim.pack manages all
            # plugins here, so drop it.
            patches = [ ];
            doCheck = false;
            doInstallCheck = false;
            # 0.13 renamed the desktop entry to org.neovim.nvim.desktop, but
            # nixpkgs' wrapper still `rm`s nvim.desktop and substitutes from it.
            postInstall = (old.postInstall or "") + ''
              mkdir -p $out/share/applications
              cp $out/share/applications/org.neovim.nvim.desktop $out/share/applications/nvim.desktop
            '';
          });

          # Every nvim-treesitter grammar + query, prebuilt for native 0.13
          # treesitter. `withAllGrammars.dependencies` is nixpkgs' own set of
          # per-language plugins (grammarPlugins provide `parser/<lang>.so`,
          # queries provide `queries/<lang>/*.scm`), so each is already a valid
          # `runtimepath` entry and no merging is needed.
          #
          # Note: the nvim-treesitter plugin itself is deliberately not loaded.
          # Its queries (rather than the raw grammar repos', which use captures
          # Neovim doesn't map to highlight groups) are what ship here.
          treesitterPlugins = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;

          # The repo's config, baked into the store.
          configDir = ./config;

          tools = with pkgs; [
            # LSP servers
            lua-language-server
            nixd
            vtsls
            basedpyright
            rust-analyzer
            gopls
            clang-tools
            yaml-language-server
            bash-language-server
            zls
            arduino-language-server
            arduino-cli

            # Formatters (conform reads them from PATH)
            stylua
            nixfmt
            prettierd
            prettier
            black
            isort
            rustfmt
            go

            # Linters (nvim-lint)
            eslint_d
            cmake-lint

            # File management / helpers
            yazi
            fd
            ripgrep
            git

            # Clipboard helpers (Wayland/X11)
            wl-clipboard
            xclip
          ];

          nvim = pkgs.wrapNeovim neovim013 {
            # Isolate this config: separate data/state dirs, plugins and lockfile.
            wrapperArgs = [
              "--set-default"
              "NVIM_APPNAME"
              "nvim-min"
              "--suffix"
              "PATH"
              ":"
              (lib.makeBinPath tools)
            ];
            configure = {
              customLuaRC = ''
                vim.opt.rtp:prepend("${configDir}")
                dofile("${configDir}/init.lua")
              '';
              # `pkgs.wrapNeovim` is the legacy wrapper: it reads plugins from
              # `configure.packages`, not a top-level `plugins` argument. Each
              # treesitter grammar/query plugin is a self-contained runtime dir,
              # so wrapNeovim puts them all on the packpath/rtp.
              packages.treesitter.start = treesitterPlugins;
            };
          };
        in
        {
          inherit nvim;
          default = nvim;
        }
      );
    };
}
