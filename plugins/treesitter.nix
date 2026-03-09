{ pkgs, ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    treesitter-context = {
      enable = true;
      settings = {
        enable = true;
        multiwindow = true;
        max_lines = 0;
        separator = "▔";
      };
    };

    ts-context-commentstring = {
      enable = true;
      disableAutoInitialization = true;
    };

    endwise.enable = true;
  };

  globals.skip_ts_context_commentstring_module = true;

  keymaps = [
    {
      mode = "n";
      key = "[c";
      action.__raw = ''
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end
      '';
      options.desc = "Go to Treesitter context";
    }
  ];
}
