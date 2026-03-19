{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-web-devicons
    ];

    luaConfigRC."lualine" = lib.nvim.dag.entryAnywhere ''
      vim.g.gitblame_display_virtual_text = 0

      require("lualine").setup({
        options = {
          theme = "eldritch",
          component_separators = "",
          section_separators = { left = "", right = "" },
          icons_enabled = true,
          globalstatus = true,
          refresh = { statusline = 1000, tabline = 1000 },
          disabled_filetypes = { statusline = { "dashboard" }, tabline = { "dashboard" } },
        },
        extensions = { "lazy" },
        sections = {
          lualine_a = { { "mode", separator = { left = "", right = "" } } },
          lualine_b = { "branch" },
          lualine_c = {
            { "filename", file_status = true, newfile_status = true, path = 0, shorting_target = 40 },
            { "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } },
            "diagnostics",
          },
          lualine_x = {
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            },
            {
              require("gitblame").get_current_blame_text,
              cond = require("gitblame").is_blame_text_available,
            },
            { "overseer" },
          },
          lualine_y = {
            "filetype",
            { "location" },
          },
          lualine_z = {
            {
              function()
                -- Show lazy.nvim update count when available
                local ok, lazy_status = pcall(require, "lazy.status")
                if ok and lazy_status.has_updates() then
                  return "󱧕 " .. lazy_status.updates()
                end
                return "󰏗 󰄵"
              end,
            },
          },
        },
      })
    '';
  };
}
