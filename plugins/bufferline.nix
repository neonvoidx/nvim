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
        numbers = "none";
        show_buffer_close_icons = false;
        themable = true;
        indicator.style = "underline";
        color_icons = true;
        separator_style = "thin";
        show_tab_indicators = false;
        show_buffer_icons = true;
        show_duplicate_prefix = false;
        max_name_length = 16;
        max_prefix_length = 10;
        tab_size = 25;
        truncate_names = true;
        hover = {
          enabled = false;
        };

      };
    };
  };

  config.vim.luaConfigRC."bufferline-pin" = lib.nvim.dag.entryAnywhere /* lua */ ''
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>",           { desc = "Toggle pin buffer" })
    vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Close non-pinned buffers" })
    vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",          { desc = "Close other buffers" })
    vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>",           { desc = "Close buffers to the right" })
    vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",            { desc = "Close buffers to the left" })
    vim.keymap.set("n", "<S-Right>", "<cmd>BufferLineMoveNext<cr>",              { desc = "Move buffer right" })
    vim.keymap.set("n", "<S-Left>", "<cmd>BufferLineMovePrev<cr>",               { desc = "Move buffer left" })
  '';
}
