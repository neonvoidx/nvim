return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      filetypes = {
        markdown = false,
        help = false,
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
            return false
          end
          return true
        end,
      },
      nes = {
        enabled = false,
      },
    },
  },
  { "leisurelicht/lualine-copilot.nvim" },
}
