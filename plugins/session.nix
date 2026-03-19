{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [ persistence-nvim ];

    luaConfigRC."session" = lib.nvim.dag.entryAnywhere ''
      require("persistence").setup({
        need = 1,
        branch = true,
      })
    '';
  };
}
