{ pkgs, lib, ... }:
{
  config.vim = {
    autocomplete.blink-cmp = {
      enable = true;

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
            "lsp"
            "path"
            "lazydev"
            "snippets"
            "buffer"
          ];
          providers = {
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
            auto_show = true;
            min_width = 60;
            border = "rounded";
          };
          list.selection = {
            preselect = false;
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
          "<Tab>" = [
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
      local function find_snippet_dir()
        if vim.env.NVIM_SNIPPETS_DIR and vim.env.NVIM_SNIPPETS_DIR ~= "" then
          return vim.env.NVIM_SNIPPETS_DIR
        end

        local cwd = vim.uv.cwd()
        local flake = cwd and vim.fs.find("flake.nix", { path = cwd, upward = true })[1] or nil
        if flake then
          local repo_root = vim.fs.dirname(flake)
          if repo_root and vim.fn.isdirectory(repo_root) == 1 then
            return repo_root .. "/snippets"
          end
        end

        return vim.fn.stdpath("config") .. "/snippets"
      end

      local snippet_dir = find_snippet_dir()

      vim.fn.mkdir(snippet_dir, "p")

      require("scissors").setup({
        snippetDir = snippet_dir,
      })
      vim.keymap.set("v", "<leader>Sa", function() require("scissors").addNewSnippet() end,
        { desc = "✀  Add Snippet" })
      vim.keymap.set("n", "<leader>Se", function() require("scissors").editSnippet() end,
        { desc = "✀  Edit Snippet" })
    '';
  };
}
