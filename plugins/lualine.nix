{ ... }:
{
  config.vim.statusline.lualine = {
    enable = true;

    globalStatus = true;
    icons.enable = true;

    refresh = {
      statusline = 1000;
      tabline    = 1000;
    };

    disabledFiletypes = [ "dashboard" ];

    sectionSeparator = {
      left  = "";
      right = "";
    };
    componentSeparator = {
      left  = "";
      right = "";
    };

    # Custom eldritch theme – NVF uses "auto" if the theme name isn't in the
    # supported list, which picks up colours from the active colorscheme.
    theme = "auto";

    activeSection = {
      a = [
        ''{ "mode", separator = { left = "", right = "" } }''
      ];
      b = [
        ''"branch"''
      ];
      c = [
        ''{ "filename", file_status = true, newfile_status = true, path = 0, shorting_target = 40 }''
        ''{ "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } }''
        ''"diagnostics"''
      ];
      x = [
        ''
          {
            require("noice").api.status.mode.get,
            cond = require("noice").api.status.mode.has,
            color = { fg = "#ff9e64" },
          }
        ''
        ''
          {
            require("gitblame").get_current_blame_text,
            cond = require("gitblame").is_blame_text_available,
          }
        ''
        ''{ "overseer" }''
      ];
      y = [
        ''"filetype"''
        ''{ "location" }''
      ];
      z = [
        ''{ function() return "󰏗 󰄵" end }''
      ];
    };
  };
}
