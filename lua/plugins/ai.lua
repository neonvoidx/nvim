return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      copilot_node_command = function()
        local nixCatsUtils = require("nixCatsUtils")
        if not nixCatsUtils.isNixCats then
          return vim.fn.expand("$HOME") .. "/.local/share/mise/installs/node/24.12.0/bin/node"
        end
      end,
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
