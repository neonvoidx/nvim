require("which-key").setup({
	preset = "helix",
	spec = {
		{
			mode = { "n" },
			{ "<leader>w", group = "+window", icon = { icon = " " } },
			{ "<leader>c", group = "+code", icon = { icon = " " } },
			{ "<leader>g", group = "+git", icon = { icon = " " } },
			{ "<leader>l", group = "+lsp", icon = { icon = " " } },
			{ "<leader>p", group = "+Yanky", icon = { icon = " " } },
			{ "<leader>u", group = "+ui", icon = { icon = " " } },
			{ "<leader>q", group = "+session", icon = { icon = " " } },
			{ "<leader>b", group = "+buffer", icon = { icon = " " } },
			{ "<leader>a", group = "+ai", icon = { icon = " " } },
			{ "<leader>s", group = "+search (fzf)", icon = { icon = " " } },
			{ "<leader>f", group = "+file", icon = { icon = " " } },
			{ "<leader>.", group = "+scratch", icon = { icon = " " } },
			{ "<leader>x", group = "+quickfix", icon = { icon = " " } },
			{ "<leader>n", group = "+notifications", icon = { icon = " " } },
		},
	},
})
