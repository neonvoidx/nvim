require("persistence").setup()

-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Load session" })
