{ pkgs, lib, ... }:
{
  config.vim = {
    treesitter = {
      enable = true;
      indent.enable = true;
      highlight.enable = true;

      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

    # ── Treesitter-context (not a native NVF module – kept as raw Lua) ────
    startPlugins = with pkgs.vimPlugins; [ nvim-treesitter-context ];

    luaConfigRC."treesitter-context" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("treesitter-context").setup({
        enable     = true,
        multiwindow = true,
        max_lines  = 0,
        separator  = "▔",
      })

      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { desc = "Go to Treesitter context" })
    '';
  };
}
