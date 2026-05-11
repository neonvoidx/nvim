if vim.env.TERM == "xterm-kitty" then
	local pass_keys = vim.api.nvim_get_runtime_file("pass_keys.py", false)[1]
	if pass_keys then
		vim.fn.mkdir(vim.fn.expand("~/.config/kitty"), "p")
		vim.fn.system({ "cp", pass_keys, vim.fn.expand("~/.config/kitty/") })
	end
	require("kitty-scrollback").setup()
end
