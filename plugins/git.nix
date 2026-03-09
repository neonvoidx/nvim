{ pkgs, inputs, ... }:
{
  plugins = {
    gitsigns = {
      enable = true;
      settings = { };
    };

    # git-blame.nvim (nixvim module: gitblame)
    gitblame = {
      enable = true;
      settings = {
        enabled = true;
        message_template = "<author> • <date> • <summary>";
        date_format = "%r";
        # Disable virtual text – lualine shows blame in the statusline instead
        display_virtual_text = false;
      };
    };

    diffview = {
      enable = true;
      settings = {
        enhanced_diff_hl = true;
        use_icons = true;
        view.merge_tool = {
          layout = "diff3_horizontal";
          winbar_info = true;
          disable_diagnostics = true;
        };
      };
    };
  };

  # git-scripts.nvim and resolved.nvim – not in nixvim or nixpkgs, use flake inputs
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "resolved-nvim";
      src = inputs.resolved-nvim;
    })
  ];

  extraConfigLua = ''
    -- resolved.nvim
    pcall(function() require("resolved").setup() end)
  '';

  extraPackages = with pkgs; [
    lazygit
    git
  ];
}
