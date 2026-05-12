local map = vim.keymap.set

require("treesitter-context").setup({
	enable = true,
	multiwindow = true,
	max_lines = 0,
	separator = "▔",
})

map("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Go to Treesitter context" })
