return {
  "eldritch-theme/eldritch.nvim",
  dir = "~/dev/eldritch.nvim",
  cache = false,
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
  },
  config = function(_, opts)
    require("eldritch").setup(opts)
    vim.cmd.colorscheme("eldritch")
  end,
}
