require("persistence").setup()

vim.keymap.set("n", "<leader>qs", function()
	require("persistence").load()
end, { desc = "Load session (cwd)" })
vim.keymap.set("n", "<leader>qS", function()
	require("persistence").select()
end, { desc = "Select session to load" })
vim.keymap.set("n", "<leader>ql", function()
	require("persistence").load({ last = true })
end, { desc = "Load last session" })

-- TODO add autocommand to auto restore if sessions available
