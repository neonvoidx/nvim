{
  pkgs,
  lib,
  userPlugins,
  ...
}:
{
  config.vim = {
    # zellij.nvim is the plugin designed to pair with zellij-autolock for the
    # "same keys in nvim and zellij" workflow.
    # nixpkgs.zellij-nvim is the archived Lilja plugin, which has a
    # different setup API and ignores the options below.
    startPlugins = [ userPlugins.zellij-nvim ];
    extraPackages = [ pkgs.zellij ];

    luaConfigRC."zellij-nav" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("zellij").setup({
        no_default_mappings = false,
        move_focus_or_tab = false,
        enabled = true,
      })
    '';
  };
}
