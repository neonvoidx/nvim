return {
  {
    "nvim-highlight-colors",
    lazy = false,
    after = function()
      require("nvim-highlight-colors").setup({ render = "virtual" })
    end,
  },
}
