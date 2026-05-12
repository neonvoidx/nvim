require("persistence").setup()

vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Load session (cwd)" })
vim.keymap.set("n", "<leader>qf", function()
  require("persistence").select()
end, { desc = "Select session to load" })

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Restore persistence session on load",
  callback = function()
    require("persistence").load()
  end,
  nested = true,
})
