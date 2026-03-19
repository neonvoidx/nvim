{ pkgs, lib, ... }:
{
  config.vim = {
    utility.motion.flash-nvim = {
      enable = true;
      setupOpts = {
        auto_jump = true;
        multi_window = false;
      };
    };

    mini.pairs = {
      enable = true;
      setupOpts.modes = {
        insert = true;
        command = false;
        terminal = false;
      };
    };

    mini.surround = {
      enable = true;
      setupOpts.mappings = {
        add = "gsa";
        delete = "gsd";
        find = "gsf";
        find_left = "gsF";
        highlight = "gsh";
        replace = "gsr";
        update_n_lines = "gsn";
      };
    };

    ui.nvim-highlight-colors = {
      enable = true;
      setupOpts.render = "virtual";
    };

    ui.illuminate = {
      enable = true;
      setupOpts.providers = [
        "lsp"
        "treesitter"
        "regex"
      ];
    };

    startPlugins = with pkgs.vimPlugins; [
      todo-comments-nvim
      numb-nvim
      overseer-nvim
      quicker-nvim
      guess-indent-nvim
    ];

    luaConfigRC."editing-extra" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── Todo-comments ───────────────────────────────────────────────
      require("todo-comments").setup({
        signs  = true,
        merge_keywords = false,
        keywords = {
          BUG    = { icon = "", color = "error" },
          FIXME  = { icon = "", color = "error" },
          HACK   = { icon = "", color = "info" },
          NOTE   = { icon = "❦", color = "info" },
          TODO   = { icon = "★", color = "actionItem" },
          WARN   = { icon = "󰀦", color = "warning" },
        },
        colors = {
          actionItem = { "ActionItem", "#f1fc79" },
          default    = { "Identifier", "#37f499" },
          error      = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
          info       = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
          warning    = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
        },
        highlight = { keyword = "bg", pattern = [[.*<(KEYWORDS)\s*]] },
        search    = {
          command = "rg",
          args    = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
          pattern = [[\b(KEYWORDS)\b]],
        },
      })

      -- ── Numb ────────────────────────────────────────────────────────
      require("numb").setup()

      -- ── Overseer ────────────────────────────────────────────────────
      require("overseer").setup({ templates = { "builtin" } })
      vim.keymap.set("n", "<leader>or", "<cmd>OverseerRun<cr>",    { desc = "Run Task" })
      vim.keymap.set("n", "<leader>ol", "<cmd>OverseerToggle<cr>", { desc = "Toggle Task List" })

      -- ── Quicker ─────────────────────────────────────────────────────
      require("quicker").setup({
        keys = {
          { ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
            desc = "Expand quickfix context" },
          { "<", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
        },
      })
      vim.keymap.set("n", "<leader>q", function() require("quicker").toggle() end, { desc = "Toggle quickfix" })

      -- ── Guess indent ────────────────────────────────────────────────
      require("guess-indent").setup()
    '';
  };
}
