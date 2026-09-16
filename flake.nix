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
    { self, nixpkgs, neovim, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      packages = perSystem (system:
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

          # Every nvim-treesitter grammar, prebuilt, for native 0.13 treesitter.
          # Neovim loads parsers from `<rtp>/parser/<lang>.so` and queries from
          # `<rtp>/queries/<lang>/*.scm`.
          parsers =
            let
              allGrammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
            in
            pkgs.runCommand "nvim-treesitter-all-parsers" { } (
              lib.concatStringsSep "\n" (
                builtins.map (g:
                  let
                    lang = lib.removePrefix "tree-sitter-" g.pname;
                  in
                  ''
                    mkdir -p $out/parser $out/queries/${lang}
                    ln -s ${g}/parser $out/parser/${lang}.so
                    cp -f ${g}/queries/*.scm $out/queries/${lang}/ 2>/dev/null || true
                  ''
                ) allGrammars
              )
            );

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
          ];

          nvim = pkgs.wrapNeovim neovim013 {
            # Isolate this config: separate data/state dirs, plugins and lockfile.
            wrapperArgs = [
              "--set-default" "NVIM_APPNAME" "nvim-min"
              "--suffix" "PATH" ":" (lib.makeBinPath tools)
            ];
            configure.customLuaRC = ''
              vim.opt.rtp:prepend("${configDir}")
              vim.opt.rtp:prepend("${parsers}")
              dofile("${configDir}/init.lua")
            '';
          };
        in
        {
          inherit nvim;
          default = nvim;
        });
    };
}