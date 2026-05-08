{ pkgs, lib, ... }:
{
  config.vim = {
    extraPackages = [
      pkgs.nodejs
      pkgs.lsof
    ];

    startPlugins = with pkgs.vimPlugins; [
      copilot-lua
      sidekick-nvim
    ];

    luaConfigRC."ai" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── GitHub Copilot ────────────────────────────────────────────────
      vim.g.copilot_completion_enabled = true

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
    '';

    luaConfigRC."sidekick" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── Sidekick ──────────────────────────────────────────────────────
      require("sidekick").setup({
        nes = {enabled=false},
        copilot={status={enabled=false}},
        cli = {
          default = "opencode",
          picker = "snacks",
          tools = {
            opencode = {},
          },
        },
      })
    '';

    luaConfigRC."sidekick-keymaps" = lib.nvim.dag.entryAnywhere /* lua */ ''
      pcall(function()
        require("which-key").add({
          { "<leader>a", group = "+ai" },
        })
      end)

      local map = vim.keymap.set
      map({ "n", "t", "i", "x" }, "<C-.>", function() require("sidekick.cli").focus() end,
        { desc = "Sidekick Focus" })
      map("n", "<leader>aa", function() require("sidekick.cli").toggle({ name = "opencode" }) end,
        { desc = "Sidekick Toggle (opencode)" })
      map("n", "<leader>as", function() require("sidekick.cli").select({ current = false }) end,
        { desc = "Sidekick Select CLI" })
      map("n", "<leader>ad", function() require("sidekick.cli").close() end,
        { desc = "Sidekick Detach CLI" })
      map("n", "<leader>aD", function()
        vim.g.copilot_completion_enabled = not vim.g.copilot_completion_enabled

        local ok_sources, sources = pcall(require, "blink.cmp.sources")
        if ok_sources then
          sources.reload("copilot")
        end

        local ok_cmp, cmp = pcall(require, "blink.cmp")
        if ok_cmp then
          cmp.hide()
          vim.schedule(function()
            cmp.show()
          end)
        end

        vim.notify(
          "Copilot completion " .. (vim.g.copilot_completion_enabled and "enabled" or "disabled"),
          vim.log.levels.INFO
        )
      end, { desc = "Toggle Copilot Completion" })
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
