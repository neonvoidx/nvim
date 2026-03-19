{ inputs, pkgs, lib, ... }:
let
  eldritch-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "eldritch.nvim";
    src = inputs.eldritch-nvim;
  };
in
{
  config.vim = {
    startPlugins = [ eldritch-nvim ];

    luaConfigRC."colorscheme" = lib.nvim.dag.entryAnywhere ''
      require("eldritch").setup({ transparent = true })
      vim.cmd.colorscheme("eldritch")
    '';
  };
}
