return {
  {
    "inc-rename.nvim",
    keys = {
      { "<leader>cr", ":IncRename ", desc = "Rename symbol", mode = { "n" } },
    },
    after = function()
      require("inc_rename").setup()
    end,
  },
}
