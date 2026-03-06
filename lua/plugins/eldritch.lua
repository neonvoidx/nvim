return {
  {
    "eldritch.nvim",
    lazy = false,
    priority = 1000,
    after = function()
      require("eldritch").setup({ transparent = true })
      vim.cmd.colorscheme("eldritch")
    end,
  },
}
