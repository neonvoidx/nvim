{ pkgs, lib, ... }:
{
  config.vim = {
    extraPackages = [
      pkgs.nodejs
      pkgs.lsof
    ];

    startPlugins = with pkgs.vimPlugins; [
      opencode-nvim
    ];

    luaConfigRC."opencode" = lib.nvim.dag.entryAnywhere /* lua */ ''
      vim.g.opencode_opts = {}
      vim.o.autoread = true
    '';

    luaConfigRC."opencode-keymaps" = lib.nvim.dag.entryAnywhere /* lua */ ''
          pcall(function()
            require("which-key").add({
              { "<leader>a", group = "+ai" },
            })
          end)

      local map = vim.keymap.set
      map({ "n", "x" }, "<leader>a.", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
      map({ "n", "x" }, "<leader>ac", function() require("opencode").select() end,                          { desc = "Select opencode…" })
      map({ "n", "t" }, "<leader>aa", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })
      map({ "v" }, "<leader>as",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
      map("n", "<leader>ad", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
      map("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
      map("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })
    '';
  };
}
