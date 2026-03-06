return {
  {
    "numb.nvim",
    lazy = false,
    after = function()
      require("numb").setup()
    end,
  },
}
