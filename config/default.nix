{
  # Nixvim configuration for neonvoidx/nvim
  # Ported from lazy.nvim configuration
  
  imports = [
    ./options.nix
    ./keymaps.nix
    ./autocommands.nix
    ./plugins
  ];

  # Enable experimental features
  enableMan = true;
  
  # Set leaders
  globals.mapleader = " ";
  globals.maplocalleader = "\\";
  
  # Color scheme
  colorschemes.eldritch.enable = true;
}
