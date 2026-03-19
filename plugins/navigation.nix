{ pkgs, lib, ... }:
{
  config.vim.extraPackages = with pkgs; [ yazi lazygit ];

  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      yazi-nvim
      yanky-nvim
      plenary-nvim
      nvim-web-devicons
    ];

    luaConfigRC."navigation" = lib.nvim.dag.entryAnywhere ''
      -- ── Yazi (file manager) ───────────────────────────────────────────
      require("yazi").setup({
        open_for_directories = true,
        pick_window_implementation = "snacks.picker",
        integrations = {
          grep_in_directory = "snacks.picker",
        },
        keymaps = { show_help = "<f1>" },
      })
      -- Disable netrw (yazi takes over directory opening)
      vim.g.loaded_netrwPlugin = 1

      local map = vim.keymap.set
      map({ "n", "v" }, "<leader>e", "<cmd>Yazi<cr>",     { desc = "Yazi (current location)" })
      map("n",          "<leader>E", "<cmd>Yazi cwd<cr>", { desc = "Yazi (cwd)" })

      -- ── Yanky (yank history) ──────────────────────────────────────────
      require("yanky").setup({
        highlight = { timer = 200 },
      })
      map({ "n", "x" }, "y",      "<Plug>(YankyYank)")
      map({ "n", "x" }, "p",      "<Plug>(YankyPutAfter)")
      map({ "n", "x" }, "P",      "<Plug>(YankyPutBefore)")
      map("n",          "<c-p>",  "<Plug>(YankyCycleForward)")
      map("n",          "<c-n>",  "<Plug>(YankyCycleBackward)")
      map("n",          "<leader>pp", "<cmd>YankyRingHistory<cr>", { desc = "Yank history" })
    '';
  };
}
