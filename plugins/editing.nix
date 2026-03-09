{ ... }:
{
  plugins = {
    # ── Mini.pairs ────────────────────────────────────────────────────────
    mini-pairs = {
      enable = true;
      settings = {
        modes = {
          insert = true;
          command = false;
          terminal = false;
        };
      };
    };

    # ── Mini.surround ─────────────────────────────────────────────────────
    mini-surround = {
      enable = true;
      settings.mappings = {
        add = "gsa";
        delete = "gsd";
        find = "gsf";
        find_left = "gsF";
        highlight = "gsh";
        replace = "gsr";
        update_n_lines = "gsn";
      };
    };

    # ── Yanky ─────────────────────────────────────────────────────────────
    yanky = {
      enable = true;
      settings.highlight.timer = 200;
    };

    # ── Overseer ──────────────────────────────────────────────────────────
    overseer = {
      enable = true;
      settings.templates = [ "builtin" ];
    };

    # ── Quicker ──────────────────────────────────────────────────────────
    quicker = {
      enable = true;
      settings.keys = [
        {
          __unkeyed-1 = ">";
          fn.__raw = ''
            function()
              require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end
          '';
          desc = "Expand quickfix context";
        }
        {
          __unkeyed-1 = "<";
          fn.__raw = ''
            function()
              require("quicker").collapse()
            end
          '';
          desc = "Collapse quickfix context";
        }
      ];
    };
  };

  keymaps = [
    # Yanky
    {
      mode = [
        "n"
        "x"
      ];
      key = "y";
      action = "<Plug>(YankyYank)";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "p";
      action = "<Plug>(YankyPutAfter)";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "P";
      action = "<Plug>(YankyPutBefore)";
    }
    {
      mode = "n";
      key = "<c-p>";
      action = "<Plug>(YankyCycleForward)";
    }
    {
      mode = "n";
      key = "<c-n>";
      action = "<Plug>(YankyCycleBackward)";
    }
    {
      mode = "n";
      key = "<leader>pp";
      action = "<cmd>YankyRingHistory<cr>";
    }
    # Overseer
    {
      mode = "n";
      key = "<leader>or";
      action = "<cmd>OverseerRun<cr>";
      options.desc = "Run Task";
    }
    {
      mode = "n";
      key = "<leader>ol";
      action = "<cmd>OverseerToggle<cr>";
      options.desc = "Toggle Task List";
    }
    # Quicker
    {
      mode = "n";
      key = "<leader>q";
      action.__raw = "function() require('quicker').toggle() end";
      options.desc = "Toggle quickfix";
    }
  ];
}
