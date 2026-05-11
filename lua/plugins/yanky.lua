require("yanky").setup({
	highlight = {
		timer = 150,
	},
})

vim.keymap.set({ "n", "x" }, "<leader>y", function()
	require("snacks").picker.yanky()
end, { desc = "Yank History" })
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { remap = true, desc = "Yank text" })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { remap = true, desc = "Put after cursor" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { remap = true, desc = "Put before cursor" })
vim.keymap.set("n", "<C-p>", "<Plug>(YankyCycleForward)", { remap = true, desc = "Next yank history entry" })
vim.keymap.set("n", "<C-n>", "<Plug>(YankyCycleBackward)", { remap = true, desc = "Previous yank history entry" })
