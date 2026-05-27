require("persistence").setup()
vim.schedule(function()
  require("persistence").load()
end)
