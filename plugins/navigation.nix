{ pkgs, lib, ... }:
{
  config.vim = {
    # ── Yazi (native NVF module) ──────────────────────────────────────────
    utility.yazi-nvim = {
      enable = true;
      setupOpts = {
        open_for_directories = true;
        keymaps.show_help = "<f1>";
      };
      # Override default mappings
      mappings = {
        openYazi    = "<leader>e";
        openYaziDir = "<leader>E";
      };
    };

    # ── Yanky (native NVF module) ─────────────────────────────────────────
    utility.yanky-nvim = {
      enable = true;
      setupOpts = {
        highlight.timer = 200;
        ring.storage = "shada";
      };
    };

    # ── yazi binary on PATH ───────────────────────────────────────────────
    extraPackages = [ pkgs.yazi ];

    # ── Yanky keymaps (NVF module doesn't expose these yet) ──────────────
    luaConfigRC."yanky-keymaps" = lib.nvim.dag.entryAnywhere ''
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
