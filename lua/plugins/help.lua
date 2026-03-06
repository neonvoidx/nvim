return {
  {
    "helpview.nvim",
    ft = "help",
    after = function()
      require("helpview").setup({
        preview = { icon_provider = "devicons" },
      })
    end,
  },
}
