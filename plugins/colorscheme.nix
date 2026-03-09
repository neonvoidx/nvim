{ pkgs, inputs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "eldritch-nvim";
      src = inputs.eldritch-nvim;
    })
  ];

  extraConfigLua = ''
    require("eldritch").setup({ transparent = true })
    vim.cmd.colorscheme("eldritch")
  '';
}
