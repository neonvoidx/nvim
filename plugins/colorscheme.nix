{
  userPlugins,
  pkgs,
  lib,
  ...
}:
let
  eldritch-nvim = userPlugins.eldritch-nvim;
in
{
  config.vim = {
    startPlugins = [ eldritch-nvim ];

    luaConfigRC."colorscheme" = lib.nvim.dag.entryAfter [ "startupConfigs" ] /* lua */ ''
      require("eldritch").setup({ transparent = true })
      vim.cmd.colorscheme("eldritch")
    '';
  };
}
