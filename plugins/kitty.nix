{ pkgs, inputs, ... }:
{
  plugins = {
    # vim-kitty-navigator (nixvim module: kitty-navigator)
    kitty-navigator.enable = true;

    # kitty-scrollback.nvim (nixvim module: kitty-scrollback)
    kitty-scrollback.enable = true;
  };
}

