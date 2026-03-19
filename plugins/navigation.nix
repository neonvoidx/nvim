{ pkgs, lib, ... }:
{
  config.vim = {
    extraPackages = [ pkgs.yazi ];
    utility.yazi-nvim = {
      enable = true;
      setupOpts = {
        open_for_directories = true;
        keymaps.show_help = "<f1>";
      };
      mappings = {
        openYazi = "<leader>e";
        openYaziDir = "<leader>E";
      };
    };

    utility.yanky-nvim = {
      enable = true;
      setupOpts = {
        highlight.timer = 200;
        ring.storage = "shada";
      };
    };

    luaConfigRC."yanky-keymaps" = lib.nvim.dag.entryAnywhere /* lua */ ''
      local map = vim.keymap.set
      map({ "n", "x" }, "y",     "<Plug>(YankyYank)")
      map({ "n", "x" }, "p",     "<Plug>(YankyPutAfter)")
      map({ "n", "x" }, "P",     "<Plug>(YankyPutBefore)")
      map("n",          "<c-p>", "<Plug>(YankyCycleForward)")
      map("n",          "<c-n>", "<Plug>(YankyCycleBackward)")
      map("n", "<leader>pp", "<cmd>YankyRingHistory<cr>", { desc = "Yank history" })

      -- Disable netrw (yazi takes over directory opening)
      vim.g.loaded_netrwPlugin = 1
    '';
  };
}
