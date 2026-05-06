{ pkgs, lib, ... }:
{
  config.vim = {
    extraPackages = [
      pkgs.nodejs
      pkgs.opencode
      pkgs.lsof
    ];

    startPlugins = with pkgs.vimPlugins; [
      copilot-lua
      sidekick-nvim
    ];

    luaConfigRC."ai" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── GitHub Copilot ────────────────────────────────────────────────
      require("copilot").setup({
        filetypes = {
          markdown = false,
          help = false,
          sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
              return false
            end
            return true
          end,
        },
        nes = { enabled = false },
      })

      -- ── Sidekick ──────────────────────────────────────────────────────
      require("sidekick").setup({
        cli = {
          default = "opencode",
          picker = "snacks",
          tools = {
            opencode = {},
          },
        },
      })

      local wk = require("which-key")
      wk.add({
        { "<leader>a", group = "+ai", icon = { icon = "󱙺 " } },
      })

      local map = vim.keymap.set
      map({ "n", "t", "i", "x" }, "<C-.>", function() require("sidekick.cli").focus() end,
        { desc = "Sidekick Focus" })
      map("n", "<leader>aa", function() require("sidekick.cli").toggle({ name = "opencode" }) end,
        { desc = "Sidekick Toggle OpenCode" })
      map("n", "<leader>as", function() require("sidekick.cli").select({ current = false }) end,
        { desc = "Sidekick Select CLI" })
      map("n", "<leader>ad", function() require("sidekick.cli").close() end,
        { desc = "Sidekick Detach CLI" })
      map({ "n", "x" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end,
        { desc = "Sidekick Send This" })
      map("n", "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,
        { desc = "Sidekick Send File" })
      map("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        { desc = "Sidekick Send Selection" })
      map({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end,
        { desc = "Sidekick Prompt" })
    '';
  };
}
