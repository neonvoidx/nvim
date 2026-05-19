{
  pkgs,
  lib,
  userPlugins,
  ...
}:
let
  opencode-nvim = userPlugins.opencode-nvim;
in
{
  config.vim = {
    startPlugins = [ opencode-nvim ];

    luaConfigRC."opencode" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("opencode").setup({
        preferred_picker = "snacks",
        preferred_completion = "blink",
        keymap_prefix = "<leader>a",
        keymap = {
          -- <leader>o gets replaced
          editor = {
            ['<leader>oa'] = { 'toggle', desc = "Toggle Opencode" },
          },
        },
      })
    '';

    luaConfigRC."opencode-keymaps" = lib.nvim.dag.entryAnywhere /* lua */ ''
      pcall(function()
        require("which-key").add({
          { "<leader>a", group = "+ai" },
        })
      end)
    '';
  };
}
