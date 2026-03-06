return {
  {
    "mini.pairs",
    lazy = false,
    after = function()
      require("mini.pairs").setup({
        modes = { insert = true, command = false, terminal = false },
      })
    end,
  },
  {
    "mini.surround",
    lazy = false,
    after = function()
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
    end,
  },
}
