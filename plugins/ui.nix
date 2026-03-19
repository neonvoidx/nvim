{ pkgs, lib, ... }:
{
  config.vim = {
    # ── Noice (native NVF module) ─────────────────────────────────────────
    ui.noice = {
      enable = true;
      setupOpts = {
        lsp = {
          progress.enabled = true;
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown"                = true;
          };
        };
        presets = {
          bottom_search    = true;
          command_palette  = true;
          inc_rename       = true;
          lsp_doc_border   = true;
          long_message_to_split = false;
        };
      };
    };

    # ── nvim-web-devicons (native NVF module) ─────────────────────────────
    visuals.nvim-web-devicons = {
      enable = true;
      setupOpts.color_icons = true;
    };

    # ── which-key (not a native NVF module – kept as raw Lua) ────────────
    startPlugins = [ pkgs.vimPlugins.which-key-nvim pkgs.vimPlugins.helpview-nvim ];

    luaConfigRC."which-key" = lib.nvim.dag.entryAnywhere ''
      require("which-key").setup({
        preset    = "helix",
        timeoutlen = 300,
        spec = {
          { mode = { "n" },
            { "<leader>w",  group = "+window",        icon = { icon = " " } },
            { "<leader>p",  group = "+Yanky",         icon = { icon = " " } },
            { "<leader>a",  group = "+ai",            icon = { icon = " " } },
            { "<leader>.",  group = "+scratch",       icon = { icon = "" } },
            { "<leader>S",  group = "+snippets",      icon = { icon = "✀" } },
            { "<leader>n",  group = "+notifications", icon = { icon = " " } },
            { "<leader>L",  group = "+LSP",           icon = { icon = " " } },
            { "<leader>o",  group = "+Overseer",      icon = { icon = "" } },
          },
        },
      })
    '';

    luaConfigRC."helpview" = lib.nvim.dag.entryAnywhere ''
      require("helpview").setup({
        preview = { icon_provider = "devicons" },
      })
    '';
  };
}
