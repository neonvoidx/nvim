return {
  {
    "lualine.nvim",
    lazy = false,
    priority = 700,
    after = function()
      vim.g.gitblame_display_virtual_text = 0
      local ok_gitblame, git_blame = pcall(require, "gitblame")
      local ok_noice, noice = pcall(require, "noice")
      local ok_sidekick_status, sidekick_status = pcall(require, "sidekick.status")

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
          lualine_x = {
            ok_noice and {
              noice.api.status.mode.get,
              cond = noice.api.status.mode.has,
              color = { fg = "#ff9e64" },
            } or nil,
            ok_gitblame and {
              git_blame.get_current_blame_text,
              cond = git_blame.is_blame_text_available,
            } or nil,
            { "overseer" },
            ok_sidekick_status and {
              function()
                return " "
              end,
              color = function()
                local status = sidekick_status.get()
                if status then
                  return status.kind == "Error" and "DiagnosticError"
                    or status.busy and "DiagnosticWarn"
                    or "Special"
                end
              end,
              cond = function()
                return sidekick_status.get() ~= nil
              end,
            } or nil,
            ok_sidekick_status and {
              function()
                local status = sidekick_status.cli()
                return " " .. (#status > 1 and #status or "")
              end,
              cond = function()
                return #sidekick_status.cli() > 0
              end,
              color = function()
                return "Special"
              end,
            } or nil,
          },
          lualine_y = {
            "filetype",
            { "location" },
          },
          lualine_z = {
            {
              function()
                return "󰏗 "
              end,
            },
          },
        },
      })
    end,
  },
}
