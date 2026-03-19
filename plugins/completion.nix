{ pkgs, lib, ... }:
{
  config.vim = {
    autocomplete.blink-cmp = {
      enable = true;

      sourcePlugins.copilot = {
        enable = true;
        package = pkgs.vimPlugins.blink-copilot;
        module = "blink-copilot";
      };

      setupOpts = {
        fuzzy = {
          sorts = [
            "exact"
            "score"
            "sort_text"
          ];
          prebuilt_binaries.download = false;
        };

        sources = {
          default = [
            "copilot"
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
          providers = {
            copilot = {
              module = "blink-copilot";
              score_offset = 4;
              async = true;
            };
            path = {
              score_offset = 5;
              opts.get_cwd = lib.generators.mkLuaInline "function(_) return vim.fn.getcwd() end";
            };
          };
        };

        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
            window.border = "rounded";
          };
          menu = {
            auto_show = true;
            min_width = 60;
            border = "rounded";
          };
          list.selection = {
            preselect = true;
            auto_insert = true;
          };
        };

        keymap = {
          "<C-k>" = [
            "select_prev"
            "fallback"
          ];
          "<C-j>" = [
            "select_next"
            "fallback"
          ];
          "<Tab>" = [
            "accept"
            "fallback"
          ];
          "<Up>" = [
            "select_prev"
            "fallback"
          ];
          "<Down>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "snippet_forward"
            "fallback"
          ];
          "<C-Tab>" = [
            "snippet_backward"
            "fallback"
          ];
          "<C-e>" = [
            "hide"
            "fallback"
          ];
          "<C-space>" = [
            "show"
            "show_documentation"
            "hide_documentation"
          ];
        };
      };
    };

    startPlugins = [ pkgs.vimPlugins.nvim-scissors ];

    luaConfigRC."scissors" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("scissors").setup({
        snippetDir = vim.fn.stdpath("config") .. "/snippets",
      })
      vim.keymap.set("v", "<leader>Sa", function() require("scissors").addNewSnippet() end,
        { desc = "✀  Add Snippet" })
      vim.keymap.set("n", "<leader>Se", function() require("scissors").editSnippet() end,
        { desc = "✀  Edit Snippet" })
    '';
  };
}
