{ pkgs, ... }:
{
  plugins.yazi = {
    enable = true;
    settings = {
      open_for_directories = true;
      pick_window_implementation = "snacks.picker";
      integrations.grep_in_directory = "snacks.picker";
      keymaps.show_help = "<f1>";
    };
  };

  globals.loaded_netrwPlugin = 1;

  extraPackages = with pkgs; [
    yazi
    fd
    ripgrep
  ];

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>e";
      action = "<cmd>Yazi<cr>";
      options.desc = "Yazi (current location)";
    }
    {
      mode = "n";
      key = "<leader>E";
      action = "<cmd>Yazi cwd<cr>";
      options.desc = "Yazi (cwd)";
    }
  ];
}
