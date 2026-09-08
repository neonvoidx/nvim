{ ... }:
{
  config.vim.utility.smart-splits = {
    enable = true;

    keymaps = {
      move_cursor_left = "<C-h>";
      move_cursor_down = "<C-j>";
      move_cursor_up = "<C-k>";
      move_cursor_right = "<C-l>";
      resize_left = "<C-S-h>";
      resize_down = "<C-S-j>";
      resize_up = "<C-S-k>";
      resize_right = "<C-S-l>";
    };
  };
}