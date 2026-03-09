{ pkgs, inputs, ... }:
{
  plugins = {
    render-markdown = {
      enable = true;
      settings = {
        file_types = [
          "markdown"
          "norg"
          "rmd"
          "org"
          "codecompanion"
        ];
        heading = {
          sign = false;
          icons = [ ];
        };
        code = {
          sign = false;
          width = "block";
          right_pad = 1;
        };
        dash.width = 50;
        checkbox = {
          unchecked.icon = "✘ ";
          checked.icon = "✔ ";
          custom.in_progress = {
            raw = "[-]";
            rendered = "◐ ";
            highlight = "RenderMarkdownUnchecked";
          };
          custom.important = {
            raw = "[!]";
            rendered = "◆ ";
            highlight = "DiagnosticError";
          };
        };
      };
    };

    markdown-preview = {
      enable = true;
      settings.auto_close = 0;
    };

    obsidian = {
      enable = true;
      settings = {
        # Upstream is deprecating `ObsidianBacklinks`-style commands in favor of
        # subcommands like `:Obsidian backlinks`. Disable legacy commands to
        # silence the warning.
        legacy_commands = false;
        workspaces = [
          {
            name = "personal";
            path = "~/vault";
          }
        ];
        ui.enable = false;
        picker.name = "snacks.pick";
        completion = {
          nvim_cmp = false;
          blink = true;
        };
      };
    };

    helpview = {
      enable = true;
      settings.preview.icon_provider = "devicons";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>oo";
      action = "<cmd>ObsidianOpen<cr>";
      options.desc = "Open Obsidian";
    }
    {
      mode = "n";
      key = "<leader>on";
      action = "<cmd>ObsidianNew<cr>";
      options.desc = "New Note";
    }
    {
      mode = "n";
      key = "<leader>os";
      action = "<cmd>ObsidianSearch<cr>";
      options.desc = "Search Notes";
    }
    {
      mode = "n";
      key = "<leader>oq";
      action = "<cmd>ObsidianQuickSwitch<cr>";
      options.desc = "Quick Switch";
    }
  ];
}
