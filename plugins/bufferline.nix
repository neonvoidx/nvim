{ lib, ... }:
{
  config.vim.tabline.nvimBufferline = {
    enable = true;

    # Override default mappings to match original keybindings
    mappings = {
      cycleNext     = "<S-l>";
      cyclePrevious = "<S-h>";
      # These map to the "]b" / "[b" aliases already handled above via cycleNext/cyclePrevious
      moveNext     = "<leader>bmn";
      movePrevious = "<leader>bmp";
      pick         = "<leader>bc";
      sortByExtension = "<leader>bse";
      sortByDirectory = "<leader>bsd";
      sortById     = "<leader>bsi";
    };

    setupOpts = {
      options = {
        mode         = "buffers";
        themable     = true;
        indicator.style = "none";
        color_icons  = true;
        separator_style = "thin";
        show_tab_indicators  = false;
        show_buffer_icons    = true;
        show_duplicate_prefix = false;
        max_name_length  = 16;
        max_prefix_length = 10;
        tab_size = 25;
        truncate_names = true;
        hover = {
          enabled = true;
          delay = 200;
          reveal = [ "close" ];
        };
        diagnostics = "nvim_lsp";
        diagnostics_indicator = lib.generators.mkLuaInline ''
          function(_, _, diagnostics_dict, _)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or "")
              s = s .. n .. sym
            end
            return s
          end
        '';
      };
    };
  };
}
