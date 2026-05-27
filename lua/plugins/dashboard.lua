vim.opt.shortmess:append("I")

local splashchoice = "shader"
local splash = require("milli").load({ splash = splashchoice })
require("dashboard").setup({
  theme = "doom",
  hide = {
    statusline = true,
    tabline = true,
    winbar = true,
  },
  config = {
    header = splash.frames[1],
    vertical_center = true,
    center = {
      {
        desc = "Find Files",
        key = "f",
        action = function()
          require("fff").find_files()
        end,
      },
      {
        desc = "Grep",
        key = "/",
        action = function()
          require("fff").live_grep()
        end,
      },
      {
        desc = "Recent Files",
        key = "r",
        action = function()
          require("fff").find_files({ title = "Recent Files" })
        end,
      },
      {
        desc = "Update Plugins",
        key = "u",
        action = function()
          vim.pack.update()
        end,
      },
      {
        desc = "Quit",
        key = "q",
        action = function()
          vim.cmd.qa()
        end,
      },
      {
        desc = "New File",
        key = "n",
        action = function()
          vim.cmd.enew()
        end,
      },
      {
        desc = "Load Session",
        key = "s",
        action = function()
          require("persistence").load()
        end,
      },
    },
    footer = {},
  },
})

require("milli").dashboard({ splash = splashchoice, loop = true })
