{ pkgs, lib, ... }:
{
  config.vim = {
    # zellij.nvim is the plugin designed to pair with zellij-autolock for the
    # "same keys in nvim and zellij" workflow.
    startPlugins = [ pkgs.vimPlugins.zellij-nvim ];

    luaConfigRC."zellij-nav" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("zellij").setup({
        no_default_mappings = false,
        move_focus_or_tab = false,
        enabled = true,
      })
    '';
  };
}
