{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      hmts-nvim          # home-manager treesitter integration
    ];

    luaConfigRC."nix-integration" = lib.nvim.dag.entryAnywhere ''
      -- hmts.nvim loads automatically via treesitter; no extra setup needed
    '';
  };
}
