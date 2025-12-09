return {
	"folke/which-key.nvim",
	vscode = false,
	opts = {
		preset = "helix",
		timeoutlen = 0,
		spec = {
			{
				mode = { "n" },
				{
					"<leader>w",
					group = "+window",
					icon = { icon = " " },
				},
				{
					"<leader>l",
					group = "+LSP",
					icon = { icon = " " },
				},
				{
					"<leader>o",
					group = "+Overseer",
					icon = {
						icon = "",
					},
				},
			},
		},
	},
}
