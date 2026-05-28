{ lib, ... }:
{
  config.vim = {
    statusline.lualine = {
      enable = true;

      globalStatus = true;
      icons.enable = true;

      refresh = {
        statusline = 1000;
        tabline = 1000;
      };

      disabledFiletypes.statusline = [ "dashboard" ];

      sectionSeparator = {
        left = "";
        right = "";
      };
      componentSeparator = {
        left = "";
        right = "";
      };

      activeSection = {
        a = [
          /* lua */ ''
            {
              "mode",
              right_padding = 2,
              color = function()
                local colors = require("eldritch.colors").default
                local mode = vim.fn.mode()
                local fg = colors.cyan

                if mode:match("^[iR]") then
                  fg = colors.green
                elseif mode:match("^[vV\22]") then
                  fg = colors.magenta or colors.pink
                elseif mode == "c" then
                  fg = colors.orange
                end

                return { fg = fg, bg = colors.bg_highlight, gui = "bold" }
              end,
            }
          ''
        ];
        b = [
          /* lua */ ''
            {
              "branch",
              icon = "",
              color = function()
                local colors = require("eldritch.colors").default
                return { fg = colors.purple or colors.magenta, bg = colors.bg_highlight }
              end,
            }
          ''
          /* lua */ ''
            {
              "diff",
              colored = true,
              diff_color = {
                added = { fg = (vim.g.__eldritch_lualine_colors or {}).green },
                modified = { fg = (vim.g.__eldritch_lualine_colors or {}).orange },
                removed = { fg = (vim.g.__eldritch_lualine_colors or {}).red },
              },
              color = function()
                local colors = require("eldritch.colors").default
                return { bg = colors.bg_highlight }
              end,
              symbols = { added = " ", modified = "󰣕 ", removed = " " }
            }
          ''
          /* lua */ ''
            {
              require("gitblame").get_current_blame_text,
              cond = require("gitblame").is_blame_text_available,
              color = function()
                local colors = require("eldritch.colors").default
                return { fg=colors.comment, bg = colors.bg_highlight }
              end,
            }
          ''
          ''{ "overseer" }''
          /* lua */ ''
            {
              function()
                if vim.bo.modified then
                  return "●"
                end

                return ""
              end,
              icon = " ",
              color = function()
                local colors = require("eldritch.colors").default
                return { fg = colors.orange, gui = "bold" }
              end,
            }
          ''
        ];
        c = [ ];
        x = [
          /* lua */ ''
            {
              "filetype",
              colored = false,
              icon_only = false,
              icon = { align = "right" },
              color = function()
                local colors = require("eldritch.colors").default
                local ft = vim.bo.filetype
                local ok, devicons = pcall(require, "nvim-web-devicons")

                if not ok then
                  return { fg = colors.cyan, bg = colors.bg_highlight, gui = "bold" }
                end

                local icon, icon_color = devicons.get_icon_color_by_filetype(ft)
                if not icon then
                  local name = vim.api.nvim_buf_get_name(0)
                  _, icon_color = devicons.get_icon_color(name, nil, { default = true })
                end

                return {
                  fg = icon_color or colors.cyan,
                  bg = colors.bg_highlight,
                  gui = "bold",
                }
              end,
            }
          ''
          /* lua */ ''
            {
              function()
                local file = vim.api.nvim_buf_get_name(0)
                if file == "" then
                  return "[No Name]"
                end

                local cwd = vim.loop.cwd()
                if cwd and file:sub(1, #cwd + 1) == cwd .. "/" then
                  return vim.fn.fnamemodify(file, ":.")
                end

                return vim.fn.fnamemodify(file, ":t")
              end,
              color = function()
                local colors = require("eldritch.colors").default
                return {
                  fg = colors.pink,
                  bg = colors.fg_gutter,
                  gui = "bold",
                }
              end,
            }
          ''
          /* lua */ ''
            {
              function()
                local buf_ft = vim.bo.filetype
                local clients = vim.lsp.get_clients({ bufnr = 0 })

                if not clients or vim.tbl_isempty(clients) then
                  return ""
                end

                for _, client in ipairs(clients) do
                  local filetypes = client.config and client.config.filetypes
                  if not filetypes or vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return ""
                  end
                end

                return ""
              end,
              icon = " ",
              color = function()
                local colors = require("eldritch.colors").default
                local buf_ft = vim.bo.filetype
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                local fg = colors.fg_dark

                if clients and not vim.tbl_isempty(clients) then
                  for _, client in ipairs(clients) do
                    local filetypes = client.config and client.config.filetypes
                    if not filetypes or vim.fn.index(filetypes, buf_ft) ~= -1 then
                      fg = colors.green
                      break
                    end
                  end
                end

                return {
                  fg = fg,
                  bg = colors.bg_highlight,
                  gui = "bold",
                }
              end,
            }
          ''
          /* lua */ ''
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
              diagnostics_color = {
                error = function()
                  local colors = require("eldritch.colors").default
                  return { fg = colors.red }
                end,
                warn = function()
                  local colors = require("eldritch.colors").default
                  return { fg = colors.orange }
                end,
                info = function()
                  local colors = require("eldritch.colors").default
                  return { fg = colors.cyan }
                end,
                hint = function()
                  local colors = require("eldritch.colors").default
                  return { fg = colors.green }
                end,
              },
            }
          ''
          /* lua */ ''
            {
              function()
                local ok, noice = pcall(require, "noice")
                if not ok then
                  return ""
                end

                return noice.api.status.mode.get()
              end,
              cond = function()
                local ok, noice = pcall(require, "noice")
                return ok and noice.api.status.mode.has()
              end,
              icon = " ",
              color = function()
                local colors = require("eldritch.colors").default
                return { fg = colors.orange }
              end,
            }
          ''
          /* lua */ ''
            {
              function()
                local line = vim.fn.line(".")
                local col = vim.fn.virtcol(".")
                return string.format("%d:%d", line, col)
              end,
              color = function()
                local colors = require("eldritch.colors").default
                local line = vim.fn.line(".")
                local total = vim.fn.line("$")
                local ratio = 0

                if total > 1 then
                  ratio = (line - 1) / (total - 1)
                end

                if ratio < 0.33 then
                  return { fg = colors.green, gui = "bold" }
                end

                if ratio < 0.66 then
                  return { fg = colors.yellow, gui = "bold" }
                end

                return { fg = colors.red, gui = "bold" }
              end,
            }
          ''
        ];
        y = [ ];
        z = [ ];
      };

      inactiveSection = {
        a = [ ];
        b = [ ];
        c = [ ];
        x = [ ];
        y = [ ];
        z = [ ];
      };
    };

    luaConfigRC.lualine-theme = lib.nvim.dag.entryBefore [ "lualine" ] /* lua */ ''
      local ok, lualine_theme = pcall(require, "lualine.themes.eldritch")
      local colors = require("eldritch.colors").default

      if ok then
        lualine_theme.normal.c = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.normal.b = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.insert.c = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.insert.b = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.visual.c = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.visual.b = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.replace.c = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.replace.b = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.command.c = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.command.b = { fg = colors.fg, bg = colors.bg_highlight }
        lualine_theme.inactive.c = { fg = colors.fg_dark, bg = colors.bg_highlight }
        lualine_theme.inactive.b = { fg = colors.fg_dark, bg = colors.bg_highlight }
        vim.g.__nvf_lualine_theme_override = lualine_theme
      end
    '';

    statusline.lualine.setupOpts.options.theme = lib.generators.mkLuaInline ''
      vim.g.__nvf_lualine_theme_override or "auto"
    '';
  };
}
