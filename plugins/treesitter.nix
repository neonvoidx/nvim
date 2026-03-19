{ pkgs, lib, ... }:
{
  config.vim = {
    # ── Core treesitter ───────────────────────────────────────────────────
    treesitter = {
      enable = true;
      indent.enable = true;
      highlight.enable = true;

      # Add every grammar available; nvf language modules add their own parsers
      # automatically – this just catches any extra ones we want.
      grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
    };

    # ── Language-specific treesitter (handled by language modules) ────────
    # Enabled in lsp.nix via vim.languages.<lang>.treesitter.enable

    # ── Treesitter-context (not a native NVF module – kept as raw Lua) ────
    startPlugins = with pkgs.vimPlugins; [ nvim-treesitter-context ];

    luaConfigRC."treesitter-context" = lib.nvim.dag.entryAnywhere ''
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
