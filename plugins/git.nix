{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      gitsigns-nvim
      git-blame-nvim
      diffview-nvim
    ];

    luaConfigRC."git" = lib.nvim.dag.entryAnywhere ''
      -- ── Gitsigns ─────────────────────────────────────────────────────
      require("gitsigns").setup()

      -- ── Git Blame ────────────────────────────────────────────────────
      require("gitblame").setup({
        enabled = true,
        message_template = "<author> • <date> <<sha>>",
        date_format = "%r",
      })
      vim.g.gitblame_display_virtual_text = 0

      -- ── Diffview ─────────────────────────────────────────────────────
      require("diffview").setup({
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
          merge_tool = {
            layout = "diff3_horizontal",
            winbar_info = true,
            disable_diagnostics = true,
          },
        },
      })

      vim.keymap.set("n", "<leader>gd", function()
        local lib = require("diffview.lib")
        if lib.get_current_view() then
          vim.cmd.DiffviewClose()
        else
          vim.cmd.DiffviewOpen()
        end
      end, { desc = "Diffview toggle" })
    '';
  };
}
