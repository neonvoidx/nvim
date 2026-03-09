{ ... }:
{
  plugins.lualine.enable = true;

  # Use extraConfigLua for the full config because sections reference other
  # plugins (noice, gitblame, sidekick) via pcall and conditional expressions.
  extraConfigLua = ''
    vim.g.gitblame_display_virtual_text = 0

    local ok_gitblame, git_blame = pcall(require, "gitblame")
    local ok_noice, noice = pcall(require, "noice")
    local ok_sidekick_status, sidekick_status = pcall(require, "sidekick.status")

    local lualine_x = {}

    if ok_noice then
      table.insert(lualine_x, {
        noice.api.status.mode.get,
        cond = noice.api.status.mode.has,
        color = { fg = "#ff9e64" },
      })
    end

    if ok_gitblame then
      table.insert(lualine_x, {
        git_blame.get_current_blame_text,
        cond = git_blame.is_blame_text_available,
      })
    end

    table.insert(lualine_x, { "overseer" })

    if ok_sidekick_status then
      table.insert(lualine_x, {
        function() return " " end,
        color = function()
          local status = sidekick_status.get()
          if status then
            return status.kind == "Error" and "DiagnosticError"
              or status.busy and "DiagnosticWarn"
              or "Special"
          end
        end,
        cond = function() return sidekick_status.get() ~= nil end,
      })
      table.insert(lualine_x, {
        function()
          local status = sidekick_status.cli()
          return " " .. (#status > 1 and #status or "")
        end,
        cond = function() return #sidekick_status.cli() > 0 end,
        color = function() return "Special" end,
      })
    end

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
      sections = {
        lualine_a = { { "mode", separator = { left = "", right = "" } } },
        lualine_b = { "branch" },
        lualine_c = {
          { "filename", file_status = true, newfile_status = true, path = 0, shorting_target = 40 },
          { "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } },
          "diagnostics",
        },
        lualine_x = lualine_x,
        lualine_y = {
          "filetype",
          { "location" },
        },
        lualine_z = {
          { function() return "󰏗 " end },
        },
      },
    })
  '';
}
