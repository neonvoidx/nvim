require("fzf-lua").setup({})
vim.keymap.set("n", "<leader><leader>", function()
	FzfLua.files()
end, { desc = "Files" })
-- TODO files at cwd vs vurrent file
vim.keymap.set("n", "<leader>ff", function()
	FzfLua.files()
end, { desc = "Files" })
vim.keymap.set("n", "<leader>fr", function()
	FzfLua.resume()
end, { desc = "Resume fzf" })
vim.keymap.set("n", "<leader>/", function()
	FzfLua.live_grep()
end, { desc = "Resume fzf" })
-- TODO add more commands here
-- https://github.com/ibhagwan/fzf-lua#commands
