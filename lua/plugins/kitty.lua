return {
  {
    "vim-kitty-navigator",
    enabled = function()
      return os.getenv("TERM") == "xterm-kitty"
    end,
    lazy = false,
    after = function()
      vim.g.kitty_navigator_no_mappings = 1
      vim.cmd([[
        noremap <silent> <c-h> :<C-U>KittyNavigateLeft<cr>
        noremap <silent> <c-l> :<C-U>KittyNavigateRight<cr>
        noremap <silent> <c-j> :<C-U>KittyNavigateDown<cr>
        noremap <silent> <c-k> :<C-U>KittyNavigateUp<cr>
      ]])
    end,
  },
  {
    "kitty-scrollback.nvim",
    enabled = function()
      return os.getenv("TERM") == "xterm-kitty"
    end,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    after = function()
      require("kitty-scrollback").setup()
    end,
  },
  {
    "vim-kitty",
    ft = "kitty",
  },
}
