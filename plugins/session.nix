{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [ persistence-nvim ];

    luaConfigRC."session" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("persistence").setup({
        need = 1,
        branch = true,
      })

      local map = vim.keymap.set
      map("n", "<leader>qs", function() require("persistence").load() end,                { desc = "Restore Session" })
      map("n", "<leader>qS", function() require("persistence").select() end,              { desc = "Select Session" })
      map("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
      map("n", "<leader>qd", function() require("persistence").stop() end,                { desc = "Don't Save Current Session" })
    '';
  };
}
