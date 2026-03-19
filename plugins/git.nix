{ pkgs, lib, ... }:
{
  config.vim = {
    # ── Gitsigns (native NVF module) ──────────────────────────────────────
    git.gitsigns = {
      enable = true;
      # Override default hunk-navigation mappings to use ]h / [h instead of ]c / [c
      mappings = {
        nextHunk     = "]h";
        previousHunk = "[h";
      };
    };

    # ── Diffview (native NVF module) ──────────────────────────────────────
    utility.diffview-nvim = {
      enable = true;
      setupOpts = {
        enhanced_diff_hl = true;
        use_icons        = true;
        view.merge_tool = {
          layout              = "diff3_horizontal";
          winbar_info         = true;
          disable_diagnostics = true;
        };
      };
    };

    # ── Git-blame (not a native NVF module) ──────────────────────────────
    startPlugins = [ pkgs.vimPlugins.git-blame-nvim ];

    luaConfigRC."git-blame" = lib.nvim.dag.entryAnywhere ''
      require("gitblame").setup({
        enabled             = true,
        message_template    = "<author> • <date> <<sha>>",
        date_format         = "%r",
        display_virtual_text = 0,
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
