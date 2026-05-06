{ pkgs, lib, ... }:
{
  config.vim = {
    ui.noice = {
      enable = true;
      setupOpts = {
        lsp = {
          progress.enabled = true;
          override = {
            "vim.lsp.util.convert_input_to_markdown_lines" = true;
            "vim.lsp.util.stylize_markdown" = true;
          };
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          inc_rename = true;
          lsp_doc_border = true;
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
    startPlugins = [
      pkgs.vimPlugins.which-key-nvim
      pkgs.vimPlugins.helpview-nvim
    ];

    luaConfigRC."which-key" = lib.nvim.dag.entryAnywhere /* lua */ ''
      local wk = require("which-key")

      wk.setup({
        preset    = "helix",
        timeoutlen = 300,
      })

      wk.add({
        { "<leader><space>", desc = "Smart Find Files",  icon = { icon = "󰈞 " }, mode = "n" },
        { "<leader>'",       desc = "Buffers",           icon = { icon = " " }, mode = "n" },
        { "<leader>/",       desc = "Grep",              icon = { icon = " " }, mode = "n" },
        { "<leader>:",       desc = "Command History",   icon = { icon = " " }, mode = "n" },
        { "<leader>.",       group = "+scratch",         icon = { icon = " " }, mode = "n" },
        { "<leader>D",       desc = "Diff vs clipboard", icon = { icon = " " }, mode = {"n", "v"} },
        { "<leader>E",       desc = "Yazi cwd",          icon = { icon = " " }, mode = "n" },
        { "<leader>l",       group = "+lsp",             icon = { icon = " " }, mode = "n" },
        { "<leader>S",       group = "+snippets",        icon = { icon = "✀ " }, mode = { "n", "v" } },
        { "<leader>Z",       desc = "Toggle Zoom",       icon = { icon = "󰊓 " }, mode = "n" },
        { "<leader>a",       group = "+ai",              icon = { icon = " " }, mode = { "n", "v" } },
        { "<leader>b",       group = "+buffers",         icon = { icon = " " }, mode = "n" },
        { "<leader>c",       group = "+code",            icon = { icon = "󰘦 " }, mode = "n" },
        { "<leader>e",       desc = "Yazi",              icon = { icon = " " }, mode = "n" },
        { "<leader>f",       group = "+find",            icon = { icon = "󰍉 " }, mode = "n" },
        { "<leader>g",       group = "+git",             icon = { icon = " " }, mode = { "n", "v" } },
        { "<leader>n",       group = "+notifications",   icon = { icon = "󰂚 " }, mode = "n" },
        { "<leader>o",       group = "+workflows",       icon = { icon = "󱞁 " }, mode = "n" },
        { "<leader>p",       group = "+yanky",           icon = { icon = " " }, mode = "n" },
        { "<leader>q",       group = "+quickfix/session",icon = { icon = " " }, mode = "n" },
        { "<leader>r",       desc = "LSP Restart",       icon = { icon = "󰜉 " }, mode = "n" },
        { "<leader>s",       group = "+search",          icon = { icon = "󰆘 " }, mode = { "n", "v" } },
        { "<leader>u",       group = "+ui",              icon = { icon = "󰔎 " }, mode = "n" },
        { "<leader>w",       group = "+window",          icon = { icon = " " }, mode = "n" },
        { "<leader>x",       group = "+trouble",         icon = { icon = " " }, mode = "n" },
        { "<leader>z",       desc = "Toggle Zen Mode",   icon = { icon = "󰰶 " }, mode = "n" },

        { "<leader>bc",      desc = "Pick buffer",                icon = { icon = "󰒉 " }, mode = "n" },
        { "<leader>bd",      desc = "Delete buffer",              icon = { icon = "󰅖 " }, mode = "n" },
        { "<leader>bm",      group = "+move",                     icon = { icon = "󰁍 " }, mode = "n" },
        { "<leader>bmn",     desc = "Move buffer next",           icon = { icon = "󰒭 " }, mode = "n" },
        { "<leader>bmp",     desc = "Move buffer previous",       icon = { icon = "󰒮 " }, mode = "n" },
        { "<leader>bP",      desc = "Close non-pinned buffers",   icon = { icon = "󰅙 " }, mode = "n" },
        { "<leader>bp",      desc = "Toggle pin buffer",          icon = { icon = "󰐃 " }, mode = "n" },
        { "<leader>bs",      group = "+sort",                     icon = { icon = "󰒺 " }, mode = "n" },
        { "<leader>bsd",     desc = "Sort by directory",          icon = { icon = " " }, mode = "n" },
        { "<leader>bse",     desc = "Sort by extension",          icon = { icon = "󰈡 " }, mode = "n" },
        { "<leader>bsi",     desc = "Sort by id",                 icon = { icon = "󰑖 " }, mode = "n" },

        { "<leader>cF",      desc = "Toggle autoformat (buffer)", icon = { icon = "󰉼 " }, mode = "n" },
        { "<leader>cR",      desc = "Rename file",                icon = { icon = "󰑕 " }, mode = "n" },
        { "<leader>cf",      desc = "Toggle autoformat",          icon = { icon = "󰉼 " }, mode = "n" },
        { "<leader>cp",      desc = "Markdown preview",           icon = { icon = "󰍔 " }, mode = "n" },
        { "<leader>cr",      desc = "Rename symbol",              icon = { icon = "󰑕 " }, mode = "n" },

        { "<leader>gB",      desc = "Git Browse",                 icon = { icon = "󰊢 " }, mode = { "n", "v" } },
        { "<leader>gL",      desc = "Git Log Line",               icon = { icon = "󱔁 " }, mode = "n" },
        { "<leader>gS",      desc = "Git Stash",                  icon = { icon = " " }, mode = "n" },
        { "<leader>gb",      desc = "Git Branches",               icon = { icon = " " }, mode = "n" },
        { "<leader>gd",      desc = "Diffview toggle",            icon = { icon = " " }, mode = "n" },
        { "<leader>gf",      desc = "Git Log File",               icon = { icon = "󰈔 " }, mode = "n" },
        { "<leader>gg",      desc = "Lazygit",                    icon = { icon = " " }, mode = "n" },
        { "<leader>gh",      group = "+hunks",                    icon = { icon = "󰊢 " }, mode = "n" },
        { "<leader>ghD",     desc = "Diff project",               icon = { icon = " " }, mode = "n" },
        { "<leader>ghP",     desc = "Preview hunk",               icon = { icon = "󰋚 " }, mode = "n" },
        { "<leader>ghR",     desc = "Reset buffer",               icon = { icon = "󰑓 " }, mode = "n" },
        { "<leader>ghb",     desc = "Blame line",                 icon = { icon = "󰊢 " }, mode = "n" },
        { "<leader>ghd",     desc = "Diff this",                  icon = { icon = " " }, mode = "n" },
        { "<leader>ghr",     desc = "Reset hunk",                 icon = { icon = "󰑓 " }, mode = { "n", "v" } },
        { "<leader>ghs",     desc = "Stage hunk",                 icon = { icon = "󰐗 " }, mode = { "n", "v" } },
        { "<leader>gl",      desc = "Git Log",                    icon = { icon = "󱔁 " }, mode = "n" },
        { "<leader>gs",      desc = "Git Status",                 icon = { icon = "󰱒 " }, mode = "n" },
        { "<leader>gt",      group = "+toggles",                  icon = { icon = " " }, mode = "n" },
        { "<leader>gtb",     desc = "Toggle blame",               icon = { icon = " " }, mode = "n" },
        { "<leader>gtd",     desc = "Toggle deleted",             icon = { icon = " " }, mode = "n" },

        { "<leader>li",      desc = "LSP Info",                   icon = { icon = " " }, mode = "n" },
        { "<leader>ll",      desc = "LSP Logs",                   icon = { icon = "󰌱 " }, mode = "n" },

        { "<leader>qS",      desc = "Select session",             icon = { icon = " " }, mode = "n" },
        { "<leader>qd",      desc = "Stop saving session",        icon = { icon = "󰑐 " }, mode = "n" },
        { "<leader>ql",      desc = "Restore last session",       icon = { icon = "󰋚 " }, mode = "n" },
        { "<leader>qq",      desc = "Toggle quickfix",            icon = { icon = "󰁨 " }, mode = "n" },
        { "<leader>qs",      desc = "Restore session",            icon = { icon = " " }, mode = "n" },

        { "<leader>xl",      desc = "Location list",              icon = { icon = "󰍉 " }, mode = "n" },
        { "<leader>xq",      desc = "Quickfix",                   icon = { icon = "󰁨 " }, mode = "n" },
        { "<leader>xs",      desc = "Symbols",                    icon = { icon = "󰘦 " }, mode = "n" },
        { "<leader>xx",      desc = "Buffer diagnostics",         icon = { icon = "󱖫 " }, mode = "n" },
      })
    '';

    luaConfigRC."helpview" = lib.nvim.dag.entryAnywhere /* lua */ ''
      require("helpview").setup({
        preview = { icon_provider = "devicons" },
      })
    '';
  };
}
