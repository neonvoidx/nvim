{ pkgs, lib, ... }:
{
  config.vim = {
    treesitter = {
      enable = true;
      indent.enable = true;
      highlight.enable = true;
      context = {
        enable = true;
        setupOpts = {
          multiwindow = true;
          max_lines = 0;
          separator = "▔";
        };
      };

      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

    startPlugins = with pkgs.vimPlugins; [ nvim-treesitter-endwise ];

    luaConfigRC."treesitter-extra" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("nvim-treesitter-endwise").init()

      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { desc = "Go to Treesitter context" })
    '';
  };
}
