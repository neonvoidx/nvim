require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
	},
})

vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle pin buffer" })
vim.keymap.set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Close non-pinned buffers" })
vim.keymap.set("n", "<S-Right", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
vim.keymap.set("n", "<S-Left>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
vim.keymap.set("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete other buffers" })
vim.keymap.set("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete buffers to the right" })
vim.keymap.set("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete buffers to the left" })
