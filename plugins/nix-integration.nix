{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      hmts-nvim # home-manager treesitter integration
    ];
  };
}
