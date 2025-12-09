{
  userPlugins,
  pkgs,
  lib,
  ...
}:
let
  vim-kitty-navigator = userPlugins.vim-kitty-navigator;
in
{
  config.vim = {
    startPlugins = [ vim-kitty-navigator ];

    luaConfigRC."kitty-navigator" = lib.nvim.dag.entryAnywhere /* lua */ ''
      vim.g.kitty_navigator_no_mappings = 1
      vim.keymap.set("n", "<C-h>", "<cmd>KittyNavigateLeft<CR>",  { silent = true })
      vim.keymap.set("n", "<C-j>", "<cmd>KittyNavigateDown<CR>",  { silent = true })
      vim.keymap.set("n", "<C-k>", "<cmd>KittyNavigateUp<CR>",    { silent = true })
      vim.keymap.set("n", "<C-l>", "<cmd>KittyNavigateRight<CR>", { silent = true })
    '';
  };
}
