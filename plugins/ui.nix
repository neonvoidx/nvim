{ pkgs, ... }:
{
  plugins = {
    # ── Which-key ─────────────────────────────────────────────────────────
    which-key = {
      enable = true;
      settings = {
        preset = "helix";
        delay = 0;
        spec = [
          {
            mode = [ "n" ];
            __unkeyed-1 = {
              __unkeyed-1 = "<leader>w";
              group = "+window";
              icon.icon = "󰖲";
            };
            __unkeyed-2 = {
              __unkeyed-1 = "<leader>p";
              group = "+Yanky";
              icon.icon = "󰅍";
            };
            __unkeyed-3 = {
              __unkeyed-1 = "<leader>a";
              group = "+ai";
              icon.icon = "󰚩";
            };
            __unkeyed-4 = {
              __unkeyed-1 = "<leader>.";
              group = "+scratch";
              icon.icon = "󰃉";
            };
            __unkeyed-5 = {
              __unkeyed-1 = "<leader>S";
              group = "+snippets";
              icon.icon = "✀";
            };
            __unkeyed-6 = {
              __unkeyed-1 = "<leader>n";
              group = "+notifications";
              icon.icon = "󰍩";
            };
            __unkeyed-7 = {
              __unkeyed-1 = "<leader>l";
              group = "+LSP";
              icon.icon = "";
            };
            __unkeyed-8 = {
              __unkeyed-1 = "<leader>c";
              group = "+code";
              icon.icon = "";
            };
            __unkeyed-9 = {
              __unkeyed-1 = "<leader>o";
              group = "+Overseer";
              icon.icon = "󰒋";
            };
            __unkeyed-10 = {
              __unkeyed-1 = "<leader>b";
              group = "Buffer";
              icon = "";
            };
            __unkeyed-11 = {
              __unkeyed-1 = "<leader>g";
              group = "Git";
              icon = "";
            };
            __unkeyed-12 = {
              __unkeyed-1 = "<leader>x";
              group = "Trouble";
              icon = "󰎟";
            };
          }
        ];
      };
    };

    # Snacks can register which-key groups in `plugins/snacks.nix` (it runs on
    # `User VeryLazy`). That integration expects which-key to be loaded.
    # Explicitly declare the dependency so Nixvim orders setup correctly.
    snacks = {
      settings.toggle.which_key = true;
    };

    # ── Noice ─────────────────────────────────────────────────────────────
    noice = {
      enable = true;
      settings = {
        # Fix: notifications appearing truncated/"folded".
        # Noice can render messages/notify in compact views depending on config.
        # Force long messages to go to a split and use the default cmdline popup.
        messages = {
          enabled = true;
          view = "notify";
          view_error = "notify";
          view_warn = "notify";
          view_history = "messages";
          view_search = "virtualtext";
        };
        notify = {
          enabled = true;
          view = "notify";
        };
        lsp = {
          progress.enabled = true;
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          inc_rename = true;
          lsp_doc_border = true;
          long_message_to_split = true;
        };
      };
    };

    # ── Flash ─────────────────────────────────────────────────────────────
    flash = {
      enable = true;
      settings = {
        auto_jump = true;
        multi_window = false;
      };
    };

    # ── Todo-comments ─────────────────────────────────────────────────────
    todo-comments = {
      enable = true;
      settings = {
        signs = true;
        merge_keywords = false;
        keywords = {
          BUG = {
            icon = "";
            color = "error";
          };
          FIXME = {
            icon = "";
            color = "error";
          };
          fixme = {
            icon = "";
            color = "error";
          };
          HACK = {
            icon = "";
            color = "info";
          };
          NOTE = {
            icon = "❦";
            color = "info";
          };
          note = {
            icon = "❦";
            color = "info";
          };
          TODO = {
            icon = "★";
            color = "actionItem";
          };
          todo = {
            icon = "★";
            color = "actionItem";
          };
          WARN = {
            icon = "󰀦";
            color = "warning";
          };
          warn = {
            icon = "󰀦";
            color = "warning";
          };
          WARNING = {
            icon = "󰀦";
            color = "warning";
          };
        };
        colors = {
          actionItem = [
            "ActionItem"
            "#f1fc79"
          ];
          default = [
            "Identifier"
            "#37f499"
          ];
          error = [
            "LspDiagnosticsDefaultError"
            "ErrorMsg"
            "#f16c75"
          ];
          info = [
            "LspDiagnosticsDefaultInformation"
            "#ebfafa"
          ];
          warning = [
            "LspDiagnosticsDefaultWarning"
            "WarningMsg"
            "#f7c67f"
          ];
        };
        highlight = {
          keyword = "bg";
          pattern = ''.*<(KEYWORDS)\s*'';
        };
        search = {
          command = "rg";
          args = [
            "--color=never"
            "--no-heading"
            "--with-filename"
            "--line-number"
            "--column"
          ];
          pattern = ''\b(KEYWORDS)\b'';
        };
      };
    };

    # ── Highlight colors ───────────────────────────────────────────────────
    highlight-colors = {
      enable = true;
      settings.render = "virtual";
    };

    # ── Guess indent ──────────────────────────────────────────────────────
    guess-indent.enable = true;
  };

  # Extra plugin not in nixvim: numb.nvim (nixpkgs vimPlugins)
  extraPlugins = [ pkgs.vimPlugins.numb-nvim ];
  extraConfigLua = ''
    require("numb").setup()
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>st";
      action.__raw = "function() Snacks.picker.todo_comments() end";
      options.desc = "Todo";
    }
    {
      mode = "n";
      key = "<leader>sT";
      action.__raw = "function() Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } }) end";
      options.desc = "Todo/Fix/Fixme";
    }
    # Flash
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "s";
      action.__raw = "function() require('flash').jump() end";
      options.desc = "Flash";
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "S";
      action.__raw = "function() require('flash').treesitter() end";
      options.desc = "Flash Treesitter";
    }
    {
      mode = "o";
      key = "r";
      action.__raw = "function() require('flash').remote() end";
      options.desc = "Remote Flash";
    }
    {
      mode = [
        "o"
        "x"
      ];
      key = "R";
      action.__raw = "function() require('flash').treesitter_search() end";
      options.desc = "Treesitter Search";
    }
    {
      mode = "c";
      key = "<c-s>";
      action.__raw = "function() require('flash').toggle() end";
      options.desc = "Toggle Flash Search";
    }
  ];
}
