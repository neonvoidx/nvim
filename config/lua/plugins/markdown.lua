-- Markdown stuff
require("render-markdown").setup({
	file_types = { "markdown" },
	anti_conceal = {
		enabled = true,
		ignore = {
			code_background = true,
			sign = true,
		},
	},
	bullet = { right_pad = 1 },
	checkbox = {
		enabled = true,
		unchecked = { icon = "▢ " },
		checked = { icon = "✓ " },
		custom = { todo = { rendered = "◯ " } },
		right_pad = 1,
	},
})
