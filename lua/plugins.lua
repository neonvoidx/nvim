local map = vim.keymap.set

vim.pack.add({
	-- Theme
	"https://github.com/eldritch-theme/eldritch.nvim",
	-- Dependencies
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/MunifTanjim/nui.nvim",
	-- UI
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/folke/todo-comments.nvim",
	"https://github.com/folke/which-key.nvim",
	-- Coding: LSP, Formatters, Lint, Autocomplete
	"https://github.com/folke/trouble.nvim",
	"https://github.com/neovim/nvim-lspconfig",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-treesitter/nvim-treesitter-context",
	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",
}, { confirm = false })

require("eldritch").setup({ transparent = true })
vim.cmd.colorscheme("eldritch")

require("treesitter-context").setup({
	enable = true,
	multiwindow = true,
	max_lines = 0,
	separator = "▔",
})
map("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Go to Treesitter context" })

require("which-key").setup({
	preset = "helix",
	spec = {
		{
			mode = { "n" },
			{ "<leader>w", group = "+window", icon = { icon = " " } },
			{ "<leader>c", group = "+code", icon = { icon = " " } },
			{ "<leader>g", group = "+git", icon = { icon = " " } },
			{ "<leader>", group = "+lsp", icon = { icon = " " } },
			{ "<leader>p", group = "+Yanky", icon = { icon = " " } },
			{ "<leader>u", group = "+ui", icon = { icon = " " } },
			{ "<leader>a", group = "+ai", icon = { icon = " " } },
			{ "<leader>x", group = "+x", icon = { icon = " " } },
			{ "<leader>.", group = "+scratch", icon = { icon = "" } },
			{ "<leader>S", group = "+snippets", icon = { icon = "✀" } },
			{ "<leader>n", group = "+notifications", icon = { icon = " " } },
			{ "<leader>L", group = "+LSP", icon = { icon = " " } },
			{
				"<leader>o",
				group = "+Overseer",
				icon = { icon = "" },
			},
		},
	},
})

require("gitsigns").setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
})

require("trouble").setup({
	modes = {
		diagnostics_buffer = {
			mode = "diagnostics",
			filter = { buf = 0 },
		},
	},
})
map("n", "<leader>xx", "<cmd>Trouble diagnostics_buffer toggle<cr>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })

require("todo-comments").setup({
	signs = true,
	merge_keywords = false,
	keywords = {
		BUG = { icon = "", color = "error" },
		FIXME = { icon = "", color = "error" },
		fixme = { icon = "", color = "error" },
		HACK = { icon = "", color = "info" },
		NOTE = { icon = "❦", color = "info" },
		note = { icon = "❦", color = "info" },
		TODO = { icon = "★", color = "actionItem" },
		todo = { icon = "★", color = "actionItem" },
		WARN = { icon = "󰀦", color = "warning" },
		warn = { icon = "󰀦", color = "warning" },
		WARNING = { icon = "󰀦", color = "warning" },
	},
	colors = {
		actionItem = { "ActionItem", "#f1fc79" },
		default = { "Identifier", "#37f499" },
		error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
		info = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
		warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
	},
	highlight = {
		keyword = "bg",
		pattern = [[.*<(KEYWORDS)\s*]],
	},
	search = {
		command = "rg",
		args = {
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
		},
		pattern = [[\b(KEYWORDS)\b]],
	},
})

require("lualine").setup({ options = { theme = "eldritch", globalstatus = true } })

require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
	},
})

local blink = require("blink.cmp")
blink.setup({
	fuzzy = {
		implementation = "prefer_rust",
		sorts = { "exact", "score", "sort_text" },
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
			window = { border = "rounded" },
		},
		trigger = { prefetch_on_insert = false },
		menu = {
			auto_show = true,
			border = "rounded",
			min_width = 60,
		},
		list = {
			selection = {
				preselect = true,
				auto_insert = true,
			},
		},
	},
	signature = {
		enabled = true,
		window = { border = "rounded" },
	},
	keymap = {
		preset = "none",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<Tab>"] = { "accept", "fallback" },
		["<C-l>"] = { "scroll_documentation_up", "fallback" },
		["<C-h>"] = { "scroll_documentation_down", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_forward", "fallback" },
		["<C-Tab>"] = { "snippet_backward", "fallback" },
		["<C-e>"] = { "hide", "fallback" },
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

require("conform").setup({
	notify_on_error = false,
	formatters = {
		prettierd = { require_cwd = true },
	},
	formatters_by_ft = {
		javascript = { "eslint_d", "prettierd" },
		typescript = { "eslint_d", "prettierd" },
		javascriptreact = { "eslint_d", "prettierd" },
		typescriptreact = { "eslint_d", "prettierd" },
		["javascript.jsx"] = { "eslint_d", "prettierd" },
		["typescript.tsx"] = { "eslint_d", "prettierd" },
		css = { "prettierd" },
		html = { "prettierd" },
		json = { "prettierd" },
		yaml = { "prettierd" },
		lua = { "stylua" },
		python = { "isort", "black" },
		markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
		["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
		nix = { "nixfmt" },
		rust = { "rustfmt" },
		go = { "gofmt" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})
map("n", "<leader>cf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify(
		"Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"),
		vim.log.levels.INFO,
		{ title = "Conform" }
	)
end, { desc = "Toggle autoformat" })
map("n", "<leader>cF", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat
	vim.notify(
		"Autoformat " .. (vim.b[bufnr].disable_autoformat and "disabled" or "enabled") .. " (buffer)",
		vim.log.levels.INFO,
		{ title = "Conform" }
	)
end, { desc = "Toggle autoformat (buffer)" })

local lint = require("lint")
lint.linters_by_ft = {
	cmake = { "cmakelint" },
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	["javascript.jsx"] = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	["typescript.tsx"] = { "eslint_d" },
}
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("lint", { clear = true }),
	callback = function()
		require("lint").try_lint()
	end,
})

local servers = {
	basedpyright = {},
	clangd = {},
	gopls = {},
	lua_ls = {},
	nixd = {},
	rust_analyzer = {},
	yamlls = {},
	vtsls = {
		settings = {
			complete_function_calls = true,
			vtsls = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
				experimental = {
					maxInlayHintLength = 30,
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
			},
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = {
					completeFunctionCalls = true,
				},
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
				preferences = {
					importModuleSpecifier = "relative",
				},
			},
		},
	},
}

local capabilities = blink.get_lsp_capabilities()
for server, config in pairs(servers) do
	config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local function lmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
		end

		lmap("gd", vim.lsp.buf.definition, "Goto definition")
		lmap("gr", vim.lsp.buf.references, "Goto references")
		lmap("gI", vim.lsp.buf.implementation, "Goto implementation")
		lmap("gy", vim.lsp.buf.type_definition, "Goto type definition")
		lmap("K", vim.lsp.buf.hover, "Hover")
		lmap("<leader>ca", vim.lsp.buf.code_action, "Code action (line)")
		lmap("<leader>cA", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = { only = { "source" }, diagnostics = {} },
			})
		end, "Code action (buffer)")
		lmap("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		lmap("<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
		lmap("<leader>ll", function()
			vim.cmd("edit " .. vim.lsp.get_log_path())
		end, "LSP Logs")
		lmap("<leader>lr", "<cmd>LspRestart<cr>", "LSP Restart")
		if vim.lsp.inlay_hint then
			pcall(vim.lsp.inlay_hint.enable, true, { bufnr = ev.buf })
		end
	end,
})
