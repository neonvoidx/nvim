return {
  {
    "which-key.nvim",
    lazy = false,
    priority = 900,
    after = function()
      require("which-key").setup({
        preset = "helix",
        timeoutlen = 0,
        spec = {
          {
            mode = { "n" },
            { "<leader>w", group = "+window", icon = { icon = " " } },
            { "<leader>p", group = "+Yanky", icon = { icon = " " } },
            { "<leader>a", group = "+ai", icon = { icon = " " } },
            { "<leader>.", group = "+scratch", icon = { icon = "" } },
            { "<leader>S", group = "+snippets", icon = { icon = "✀" } },
            { "<leader>n", group = "+notifications", icon = { icon = " " } },
            { "<leader>l", group = "+LSP", icon = { icon = " " } },
            { "<leader>o", group = "+Overseer", icon = { icon = "" } },
          },
        },
      })
    end,
  },
}
