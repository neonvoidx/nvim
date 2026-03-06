return {
  {
    "persistence.nvim",
    event = "BufReadPre",
    after = function()
      require("persistence").setup({ need = 1, branch = true })
    end,
  },
}
