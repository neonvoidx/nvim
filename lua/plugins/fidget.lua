require("fidget").setup({
  display = { done_icon = "✓ " },
  notification = {
    override_vim_notify = true,
    window = { border = "none", tabstop = 2 },
  },
})

vim.keymap.set("n", "<leader>nn", "<cmd>Fidget clear active<cr>", { desc = "Clear notifications", silent = true })
vim.keymap.set(
  "n",
  "<leader>nc",
  "<cmd>Fidget clear_history<cr>",
  { desc = "Clear notification history", silent = true }
)
vim.keymap.set("n", "<leader>nh", "<cmd>Fidget history<cr>", { desc = "Notification history", silent = true })
