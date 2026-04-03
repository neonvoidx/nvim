{ lib, ... }:
{
  config.vim.tabline.nvimBufferline = {
    enable = true;

    mappings = {
      cycleNext = "<S-l>";
      cyclePrevious = "<S-h>";
      moveNext = "<leader>bmn";
      movePrevious = "<leader>bmp";
      pick = "<leader>bc";
      sortByExtension = "<leader>bse";
      sortByDirectory = "<leader>bsd";
      sortById = "<leader>bsi";
    };

    setupOpts = {
      options = {
        mode = "buffers";
        themable = true;
        indicator.style = "none";
        color_icons = true;
        separator_style = "thin";
        show_tab_indicators = false;
        show_buffer_icons = true;
        show_duplicate_prefix = false;
        max_name_length = 16;
        max_prefix_length = 10;
        tab_size = 25;
        truncate_names = true;
      };
    };
  };

  config.vim.luaConfigRC."bufferline-pin" = lib.nvim.dag.entryAnywhere /* lua */ ''
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>",           { desc = "Toggle pin buffer" })
    vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Close non-pinned buffers" })
  '';
}
