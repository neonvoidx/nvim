-- Navigation: smart-splits, yazi.nvim
local map = vim.keymap.set

-- ── smart-splits ──────────────────────────────────────────────────────
require("smart-splits").setup({})
map("n", "<C-h>", require("smart-splits").move_cursor_left)
map("n", "<C-j>", require("smart-splits").move_cursor_down)
map("n", "<C-k>", require("smart-splits").move_cursor_up)
map("n", "<C-l>", require("smart-splits").move_cursor_right)
map("n", "<C-S-h>", require("smart-splits").resize_left)
map("n", "<C-S-j>", require("smart-splits").resize_down)
map("n", "<C-S-k>", require("smart-splits").resize_up)
map("n", "<C-S-l>", require("smart-splits").resize_right)

-- ── yazi ──────────────────────────────────────────────────────────────
require("yazi").setup({
  open_for_directories = true,
  disable_netrw = true,
  show_help = "<f1>",
  floating_window_scaling_factor = 0.98,
})

map("n", "<leader>e", function() require("yazi").yazi() end, { desc = "Yazi" })
map("n", "<leader>E", function() require("yazi").yazi(nil, vim.fn.getcwd()) end, { desc = "Yazi cwd" })
