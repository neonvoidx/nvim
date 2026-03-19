{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      vim-kitty
    ];
  };
}
