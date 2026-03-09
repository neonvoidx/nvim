{ pkgs, inputs, ... }:
{
  plugins = {
    # vim-kitty-navigator (nixvim module: kitty-navigator)
    kitty-navigator.enable = true;

    # kitty-scrollback.nvim (nixvim module: kitty-scrollback)
    kitty-scrollback.enable = true;
  };

  # vim-kitty: filetype detection for Kitty config files
  # Not in nixvim or nixpkgs – use flake input
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "vim-kitty";
      src = inputs.vim-kitty;
    })
  ];
}
