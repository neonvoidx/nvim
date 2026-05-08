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
        enabled = lib.generators.mkLuaInline ''
          function()
            return not vim.tbl_contains({ "oil" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
          end
        '';

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
            "lazydev"
            "snippets"
            "buffer"
          ];
          providers = {
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              score_offset = 4;
              async = true;
            };
            path = {
              name = "path";
              score_offset = 5;
              opts.get_cwd = lib.generators.mkLuaInline "function(_) return vim.fn.getcwd() end";
            };
            lazydev = {
              name = "LazyDev";
              module = "lazydev.integrations.blink";
              score_offset = 6;
            };
            lsp = {
              name = "LSP";
              module = "blink.cmp.sources.lsp";
              score_offset = 7;
            };
          };
        };

        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
            window.border = "rounded";
          };
          trigger.prefetch_on_insert = false;
          menu = {
            auto_show = false;
            min_width = 60;
            border = "rounded";
          };
          list.selection = {
            preselect = true;
            auto_insert = false;
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
          "<CR>" = [
            "accept"
            "fallback"
          ];
          "<C-l>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-h>" = [
            "scroll_documentation_down"
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

        cmdline = {
          enabled = false;
        };

        signature = {
          enabled = true;
          window.border = "rounded";
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
