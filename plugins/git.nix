{ pkgs, lib, ... }:
{
  config.vim = {
    git.gitsigns = {
      enable = true;
      mappings = {
        nextHunk = "]h";
        previousHunk = "[h";
        stageHunk = null;
        undoStageHunk = null;
        resetHunk = null;
        stageBuffer = null;
        resetBuffer = null;
        previewHunk = null;
        blameLine = null;
        toggleBlame = null;
        diffThis = null;
        diffProject = null;
        toggleDeleted = null;
      };
    };

    binds.whichKey.register."<leader>h" = lib.mkForce null;
    binds.whichKey.register."<leader>t" = lib.mkForce null;

    utility.diffview-nvim = {
      enable = true;
      setupOpts = {
        enhanced_diff_hl = true;
        use_icons = true;
        view.merge_tool = {
          layout = "diff3_horizontal";
          winbar_info = true;
          disable_diagnostics = true;
        };
      };
    };

    startPlugins = [ pkgs.vimPlugins.git-blame-nvim ];

    luaConfigRC."git-blame" = lib.nvim.dag.entryAnywhere /* lua */ ''
      local wk = require("which-key")

      require("gitblame").setup({
        enabled             = true,
        message_template    = "<author> • <date> <<sha>>",
        date_format         = "%r",
        display_virtual_text = 0,
      })

      wk.add({
        { "<leader>gh", group = "+hunks",   icon = { icon = "󰊢 " } },
        { "<leader>gt", group = "+toggles", icon = { icon = " " } },
      })

      pcall(vim.keymap.del, "n", "<leader>hb")
      pcall(vim.keymap.del, "n", "<leader>hd")
      pcall(vim.keymap.del, "n", "<leader>hD")
      pcall(vim.keymap.del, "n", "<leader>hP")
      pcall(vim.keymap.del, "n", "<leader>hR")
      pcall(vim.keymap.del, "n", "<leader>hr")
      pcall(vim.keymap.del, "n", "<leader>hs")
      pcall(vim.keymap.del, "v", "<leader>hr")
      pcall(vim.keymap.del, "v", "<leader>hs")
      pcall(vim.keymap.del, "n", "<leader>tb")
      pcall(vim.keymap.del, "n", "<leader>td")

      vim.keymap.set("n", "<leader>gd", function()
        local lib = require("diffview.lib")
        if lib.get_current_view() then
          vim.cmd.DiffviewClose()
        else
          vim.cmd.DiffviewOpen()
        end
      end, { desc = "Diffview toggle" })

      vim.keymap.set("n", "<leader>ghb", function()
        require("gitsigns").blame_line({ full = true })
      end, { desc = "Blame line" })

      vim.keymap.set("n", "<leader>ghd", function()
        require("gitsigns").diffthis()
      end, { desc = "Diff this" })

      vim.keymap.set("n", "<leader>ghD", function()
        require("gitsigns").diffthis("~")
      end, { desc = "Diff project" })

      vim.keymap.set("n", "<leader>ghP", function()
        require("gitsigns").preview_hunk()
      end, { desc = "Preview hunk" })

      vim.keymap.set("n", "<leader>ghR", function()
        require("gitsigns").reset_buffer()
      end, { desc = "Reset buffer" })

      vim.keymap.set("n", "<leader>ghr", function()
        require("gitsigns").reset_hunk()
      end, { desc = "Reset hunk" })

      vim.keymap.set("v", "<leader>ghr", function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset hunk" })

      vim.keymap.set("n", "<leader>ghs", function()
        require("gitsigns").stage_hunk()
      end, { desc = "Stage hunk" })

      vim.keymap.set("v", "<leader>ghs", function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage hunk" })

      vim.keymap.set("n", "<leader>gtb", function()
        require("gitsigns").toggle_current_line_blame()
      end, { desc = "Toggle blame" })

      vim.keymap.set("n", "<leader>gtd", function()
        require("gitsigns").toggle_deleted()
      end, { desc = "Toggle deleted" })
    '';
  };
}
