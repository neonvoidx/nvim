return {
  {
    "gitsigns.nvim",
    lazy = false,
    after = function()
      require("gitsigns").setup()
    end,
  },
  {
    "git-blame.nvim",
    event = "User VeryLazy",
    after = function()
      require("gitblame").setup({
        enabled = true,
        message_template = "<author> • <date> <<sha>>",
        date_format = "%r",
      })
    end,
  },
  {
    "git-scripts.nvim",
    event = {
      "BufReadPre " .. vim.fn.expand("~") .. "/vault/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/vault/*.md",
    },
    after = function()
      local gitscripts = require("git-scripts")
      gitscripts.setup({ default_keymaps = false, commit_on_save = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
        callback = function()
          gitscripts.async_pull()
        end,
        desc = "Auto pull repo on enter",
      })
    end,
  },
  {
    "resolved-nvim",
    event = "User VeryLazy",
    after = function()
      require("resolved").setup()
    end,
  },
}
