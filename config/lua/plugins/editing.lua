local map = vim.keymap.set

-- ── yanky ─────────────────────────────────────────────────────────────
require("yanky").setup({
	highlight = { timer = 200 },
	ring = { storage = "shada" },
})
map({ "n", "x" }, "y", "<Plug>(YankyYank)")
map("n", "p", "<Plug>(YankyPutAfterLinewise)")
map("n", "P", "<Plug>(YankyPutBeforeLinewise)")
map("x", "p", "<Plug>(YankyPutAfter)")
map("x", "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyCycleForward)")
map("n", "<c-n>", "<Plug>(YankyCycleBackward)")
map("n", "<leader>pp", "<cmd>YankyRingHistory<cr>", { desc = "Yank history" })

-- ── numb ──────────────────────────────────────────────────────────────
require("numb").setup()

-- ── guess-indent ──────────────────────────────────────────────────────
require("guess-indent").setup()
