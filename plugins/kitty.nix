{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      vim-kitty          # syntax highlighting for kitty.conf
    ];

    luaConfigRC."kitty" = lib.nvim.dag.entryAnywhere ''
      -- Kitty navigator mappings are handled in keymaps.lua
      -- (checked at runtime via os.getenv("TERM") == "xterm-kitty")
    '';
  };
}
