{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      noice-nvim
      nui-nvim
      which-key-nvim
      helpview-nvim
      nvim-web-devicons
    ];

    luaConfigRC."ui" = lib.nvim.dag.entryAnywhere ''
      -- ── Noice (UI overhaul) ───────────────────────────────────────────
      require("noice").setup({
        lsp = {
          progress = { enabled = true },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          inc_rename = true,
          lsp_doc_border = true,
          long_message_to_split = false,
        },
      })

      -- ── Which-key ─────────────────────────────────────────────────────
      require("which-key").setup({
        preset = "helix",
        timeoutlen = 0,
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

      -- ── HelpView (enhanced help pages) ───────────────────────────────
      require("helpview").setup({
        preview = { icon_provider = "devicons" },
      })
    '';
  };
}
