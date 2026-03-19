{ inputs, pkgs, lib, ... }:
let
  vim-kitty = pkgs.vimUtils.buildVimPlugin {
    name = "vim-kitty";
    src = inputs.vim-kitty;
  };
in
{
  config.vim = {
    startPlugins = [ vim-kitty ];
  };
}
