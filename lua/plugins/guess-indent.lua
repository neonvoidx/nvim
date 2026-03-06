return {
  {
    "guess-indent.nvim",
    lazy = false,
    after = function()
      require("guess-indent").setup()
    end,
  },
}
