return {
  {
    "yazi.nvim",
    event = "User VeryLazy",
    beforeAll = function()
      vim.g.loaded_netrwPlugin = 1
    end,
    after = function()
      require("yazi").setup({
        open_for_directories = true,
        pick_window_implementation = "snacks.picker",
        integrations = { grep_in_directory = "snacks.picker" },
        keymaps = { show_help = "<f1>" },
      })
    end,
    keys = {
      { "<leader>e", mode = { "n", "v" }, "<cmd>Yazi<cr>",     desc = "Yazi (current location)" },
      { "<leader>E",                       "<cmd>Yazi cwd<cr>", desc = "Yazi (cwd)" },
    },
  },
}
