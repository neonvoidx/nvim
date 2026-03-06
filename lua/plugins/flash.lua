return {
  {
    "flash.nvim",
    event = "User VeryLazy",
    after = function()
      require("flash").setup({ auto_jump = true, multi_window = false })
    end,
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,             desc = "Remote Flash" },
      { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },       function() require("flash").toggle() end,             desc = "Toggle Flash Search" },
    },
  },
}
