local map = vim.keymap.set
local is_kitty = vim.env.TERM == "xterm-kitty"
local function project_root()
	local cwd = vim.fn.getcwd()
	local buf_path = vim.api.nvim_buf_get_name(0)
	local start = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or cwd
	local git_dir = vim.fs.find(".git", { path = start, upward = true })[1]

	if git_dir then
		return vim.fn.fnamemodify(git_dir, ":h")
	end

	return cwd
end

vim.pack.add({
	-- Theme
	"https://github.com/eldritch-theme/eldritch.nvim",
	-- Dependencies
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	-- Buffers
	"https://github.com/akinsho/bufferline.nvim",
	-- Statusline
	"https://github.com/nvim-lualine/lualine.nvim",
	-- Folke plugins
	"https://github.com/folke/todo-comments.nvim", -- highlight TODOs
	"https://github.com/folke/which-key.nvim", -- keymap popup
	"https://github.com/folke/snacks.nvim", -- fuzzy find, dashboard, file picker etc
	"https://github.com/folke/flash.nvim", -- jump search
	"https://github.com/folke/persistence.nvim", -- Session management
	-- Yazi instead of netrw
	"https://github.com/mikavilpas/yazi.nvim",
	-- Better clipboard/paste
	"https://github.com/gbprod/yanky.nvim",
	-- Kitty scrollback and navigation
	"https://github.com/knubie/vim-kitty-navigator",
	"https://github.com/mikesmithgh/kitty-scrollback.nvim",
	-- Coding: LSP, Formatters, Lint, Autocomplete, treesitter
	"https://github.com/neovim/nvim-lspconfig", -- default LSP configs
	"https://github.com/stevearc/conform.nvim", -- Formatter
	"https://github.com/mfussenegger/nvim-lint", -- Linting
	"https://github.com/nvim-treesitter/nvim-treesitter", -- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter-context", -- TS context for keeping scopes in vision
	-- Git
	"https://github.com/lewis6991/gitsigns.nvim", -- git signs in gutter and blame lines
}, { confirm = false })

-- Colorscheme
require("eldritch").setup({ transparent = true })
vim.cmd.colorscheme("eldritch")

-- Statusline
require("lualine").setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
		},
		disabled_filetypes = {
			statusline = { "dashboard" },
		},
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		theme = "eldritch",
	},
	sections = {
		lualine_a = {
			{ "mode", separator = { left = "", right = "" } },
		},
		lualine_b = { "branch" },
		lualine_c = {
			{ "filename", file_status = true, newfile_status = true, path = 0, shorting_target = 40 },
			{ "diff", symbols = { added = " ", modified = "󰣕 ", removed = " " } },
			"diagnostics",
		},
		lualine_x = {
			-- 	{
			-- 		function()
			-- 			return require("noice").api.status.mode.get()
			-- 		end,
			-- 		cond = function()
			-- 			local ok, noice = pcall(require, "noice")
			-- 			return ok and noice.api.status.mode.has()
			-- 		end,
			-- 		color = { fg = "#ff9e64" },
			-- 	},
			-- 	{
			-- 		function()
			-- 			return require("gitblame").get_current_blame_text()
			-- 		end,
			-- 		cond = function()
			-- 			local ok, gitblame = pcall(require, "gitblame")
			-- 			return ok and gitblame.is_blame_text_available()
			-- 		end,
			-- 	},
		},
		lualine_y = {
			"filetype",
			{ "location" },
		},
		lualine_z = {},
	},
})

-- New ui for neovim
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = "cmd",
		cmd = {
			height = 0.5,
		},
		dialog = {
			height = 0.5,
		},
		msg = {
			height = 0.5,
			timeout = 4000,
		},
		pager = {
			height = 1,
		},
	},
})

-- Bufferline
require("bufferline").setup({
	options = {
		diagnostics = "nvim_lsp",
		always_show_bufferline = true,
	},
})

-- Kitty navigator kitty scrollback and vimkitty
if is_kitty then
	local pass_keys = vim.api.nvim_get_runtime_file("pass_keys.py", false)[1]
	if pass_keys then
		vim.fn.mkdir(vim.fn.expand("~/.config/kitty"), "p")
		vim.fn.system({ "cp", pass_keys, vim.fn.expand("~/.config/kitty/") })
	end
	require("kitty-scrollback").setup()
end

-- Yanky
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

-- Flash
local flash = require("flash")
flash.setup({
	auto_jump = true,
	multi_window = false,
})
vim.keymap.set({ "n", "x", "o" }, "s", function()
	flash.jump()
end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.treesitter()
end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
	flash.remote()
end, { desc = "Remote Flash" })
vim.keymap.set({ "x", "o" }, "R", function()
	flash.treesitter_search()
end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function()
	flash.toggle()
end, { desc = "Toggle Flash Search" })

-- Treesitter context
require("treesitter-context").setup({
	enable = true,
	multiwindow = true,
	max_lines = 0,
	separator = "▔",
})
map("n", "[c", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Go to Treesitter context" })

-- Which-key
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
			{ "<leader>b", group = "+buffer", icon = { icon = " " } },
			{ "<leader>a", group = "+ai", icon = { icon = " " } },
			{ "<leader>s", group = "+snacks", icon = { icon = "󱥰 " } },
			{ "<leader>f", group = "+file", icon = { icon = " " } },
			{ "<leader>.", group = "+scratch", icon = { icon = " " } },
			{ "<leader>x", group = "+x", icon = { icon = " " } },
			{ "<leader>n", group = "+notifications", icon = { icon = " " } },
			{ "<leader>l", group = "+LSP", icon = { icon = " " } },
		},
	},
})

-- Git signs
require("gitsigns").setup({
	current_line_blame = true,
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
	},
})

-- TODO-comments
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

-- Snacks
require("snacks").setup({
	animate = { enabled = true },
	bigfile = { enabled = true },
	dim = { enabled = true },
	scope = { enabled = true },
	rename = { enabled = true },
	git = { enabled = false },
	notifier = { enabled = true, timeout = 3000 },
	quickfile = { enabled = true },
	scroll = { enabled = true },
	input = { enabled = true },
	lazygit = { enabled = true },
	statuscolumn = {
		enabled = true,
		left = { "sign" },
		right = { "fold", "git", "mark" },
		folds = {
			open = false,
			git_hl = true,
		},
	},
	indent = {
		enabled = true,
		hl = {
			"SnacksIndent1",
			"SnacksIndent2",
			"SnacksIndent3",
			"SnacksIndent4",
			"SnacksIndent5",
			"SnacksIndent6",
			"SnacksIndent7",
			"SnacksIndent8",
		},
	},
	picker = { enabled = true },
	dashboard = {
		enabled = true,
		pane_gap = 6,
		preset = {
			header = [[
                        ░██                
                                           
  ░████████  ░██    ░██ ░██░█████████████  
  ░██    ░██ ░██    ░██ ░██░██   ░██   ░██ 
  ░██    ░██  ░██  ░██  ░██░██   ░██   ░██ 
  ░██    ░██   ░██░██   ░██░██   ░██   ░██ 
  ░██    ░██    ░███    ░██░██   ░██   ░██ ]],
			keys = {
				{
					icon = "󰈞 ",
					key = "f",
					desc = "Find file",
					action = function()
						Snacks.picker.files({ cwd = vim.uv.cwd() })
					end,
				},
				{
					icon = " ",
					key = "n",
					desc = "New file",
					action = function()
						vim.cmd("enew")
					end,
				},
				{
					icon = " ",
					key = "g",
					desc = "Find text (grep)",
					action = function()
						Snacks.picker.grep()
					end,
				},
				{
					icon = " ",
					key = "r",
					desc = "Recent files",
					action = function()
						Snacks.picker.recent({ filter = { cwd = true } })
					end,
				},
				{
					icon = "󰁯 ",
					key = "s",
					desc = "Restore session",
					action = function()
						require("persistence").load()
					end,
				},
				{
					icon = "󰩈 ",
					key = "q",
					desc = "Quit",
					action = function()
						vim.cmd("qa")
					end,
				},
			},
		},
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{
				title = "Recent Files",
				icon = " ",
				section = "recent_files",
				gap = 1,
				pane = 2,
				indent = 2,
				padding = 1,
				cwd = true,
				text = function(item, ctx)
					local dir = vim.fn.fnamemodify(item.file, ":h:~")
					local max_dir = math.max((ctx.width or 60) - 32, 12)
					if #dir > max_dir then
						dir = vim.fn.pathshorten(dir)
					end
					if #dir > max_dir then
						dir = "..." .. dir:sub(-(max_dir - 3))
					end
					return {
						Snacks.dashboard.icon(item.file, "file"),
						{ " ", width = 1 },
						{ vim.fn.fnamemodify(item.file, ":t"), hl = "file", width = 28 },
						{ dir, hl = "SnacksDashboardDir" },
					}
				end,
			},
			{
				title = "Git Status",
				icon = " ",
				pane = 2,
				section = "terminal",
				enabled = function()
					return Snacks.git.get_root() ~= nil
				end,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60,
				indent = 2,
			},
		},
	},
})
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
	.option("conceallevel", {
		off = 0,
		on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
	})
	:map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.dim():map("<leader>uD")

map("n", "<leader><space>", function()
	Snacks.picker.smart({ cwd = vim.uv.cwd() })
end, { desc = "Smart Find Files" })
map("n", "<leader>'", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>/", function()
	Snacks.picker.grep({ cwd = vim.uv.cwd() })
end, { desc = "Grep" })
map("n", "<leader>:", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>fb", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
map("n", "<leader>fc", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File" })
map("n", "<leader>ff", function()
	Snacks.picker.files({ cwd = vim.uv.cwd() })
end, { desc = "Find Files" })
map("n", "<leader>fg", function()
	Snacks.picker.git_files()
end, { desc = "Find Git Files" })
map("n", "<leader>fp", function()
	Snacks.picker.projects()
end, { desc = "Projects" })
map("n", "<leader>fr", function()
	Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent" })
map("n", "<leader>gb", function()
	Snacks.picker.git_branches()
end, { desc = "Git Branches" })
map("n", "<leader>gl", function()
	Snacks.picker.git_log()
end, { desc = "Git Log" })
map("n", "<leader>gL", function()
	Snacks.picker.git_log_line()
end, { desc = "Git Log Line" })
map("n", "<leader>gs", function()
	Snacks.picker.git_status()
end, { desc = "Git Status" })
map("n", "<leader>gS", function()
	Snacks.picker.git_stash()
end, { desc = "Git Stash" })
map("n", "<leader>gf", function()
	Snacks.picker.git_log_file()
end, { desc = "Git Log File" })
map("n", "<leader>sb", function()
	Snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("n", "<leader>sB", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
map("n", "<leader>sg", function()
	Snacks.picker.grep({ cwd = vim.uv.cwd() })
end, { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", function()
	Snacks.picker.grep_word({ cwd = vim.uv.cwd() })
end, { desc = "Word/Selection" })
map("n", [[<leader>s"]], function()
	Snacks.picker.registers()
end, { desc = "Registers" })
map("n", "<leader>s/", function()
	Snacks.picker.search_history()
end, { desc = "Search History" })
map("n", "<leader>sa", function()
	Snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("n", "<leader>sc", function()
	Snacks.picker.command_history()
end, { desc = "Command History" })
map("n", "<leader>sC", function()
	Snacks.picker.commands()
end, { desc = "Commands" })
map("n", "<leader>sh", function()
	Snacks.picker.help()
end, { desc = "Help Pages" })
map("n", "<leader>sH", function()
	Snacks.picker.highlights()
end, { desc = "Highlights" })
map("n", "<leader>si", function()
	Snacks.picker.icons()
end, { desc = "Icons" })
map("n", "<leader>sj", function()
	Snacks.picker.jumps()
end, { desc = "Jumps" })
map("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end, { desc = "Keymaps" })
map("n", "<leader>sl", function()
	Snacks.picker.loclist()
end, { desc = "Location List" })
map("n", "<leader>sm", function()
	Snacks.picker.marks()
end, { desc = "Marks" })
map("n", "<leader>sM", function()
	Snacks.picker.man()
end, { desc = "Man Pages" })
map("n", "<leader>sq", function()
	Snacks.picker.qflist()
end, { desc = "Quickfix List" })
map("n", "<leader>sR", function()
	Snacks.picker.resume()
end, { desc = "Resume" })
map("n", "<leader>su", function()
	Snacks.picker.undo()
end, { desc = "Undo History" })
map("n", "<leader>uC", function()
	Snacks.picker.colorschemes()
end, { desc = "Colorschemes" })
map("n", "<leader>st", function()
	Snacks.picker.todo_comments()
end, { desc = "Todo" })
map("n", "<leader>sT", function()
	Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Todo/Fix/Fixme" })
map("n", "gd", function()
	Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
map("n", "gD", function()
	Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })
map("n", "gr", function()
	Snacks.picker.lsp_references()
end, { desc = "References", nowait = true })
map("n", "gI", function()
	Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("n", "gy", function()
	Snacks.picker.lsp_type_definitions()
end, { desc = "Goto Type Definition" })
map("n", "<leader>ss", function()
	Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
map("n", "<leader>sS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })
map("n", "<leader>z", function()
	Snacks.zen()
end, { desc = "Toggle Zen Mode" })
map("n", "<leader>Z", function()
	Snacks.zen.zoom()
end, { desc = "Toggle Zoom" })
map("n", "<leader>..", function()
	Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>.s", function()
	Snacks.scratch.select()
end, { desc = "Select Scratch Buffer" })
map("n", "<leader>nn", function()
	Snacks.notifier.show_history()
end, { desc = "Notification History" })
map("n", "<leader>nd", function()
	Snacks.notifier.hide()
end, { desc = "Notifications hide" })
map("n", "<leader>un", function()
	Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>cR", function()
	Snacks.rename.rename_file()
end, { desc = "Rename File" })
map({ "n", "v" }, "<leader>gB", function()
	Snacks.gitbrowse()
end, { desc = "Git Browse" })
map("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "Lazygit" })
map({ "n", "i", "t" }, "<C-/>", function()
	Snacks.terminal()
end, { desc = "Toggle Terminal" })
map({ "n", "t" }, "]]", function()
	Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })
map({ "n", "t" }, "[[", function()
	Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev Reference" })

-- Persistence (session management)
require("persistence").setup()

-- Yazi
require("yazi").setup({
	open_for_directories = true,
})
map("n", "<leader>e", function()
	local buf_path = vim.api.nvim_buf_get_name(0)
	local path = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or vim.fn.getcwd()
	require("yazi").yazi(nil, path)
end, { desc = "Yazi (here)" })
map("n", "<leader>E", function()
	require("yazi").yazi(nil, project_root())
end, { desc = "Yazi (root)" })

-- Conform (code formatting)
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

-- Linting
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

-- LSP
local servers = {
	basedpyright = {},
	clangd = {},
	gopls = {},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = {
			".luarc.json",
			".luarc.jsonc",
			".luacheckrc",
			".stylua.toml",
			"stylua.toml",
			"selene.toml",
			"selene.yml",
			".git",
		},
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
				diagnostics = { globals = { "vim" } }, -- Recognize 'vim' global
			},
		},
	},
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
-- enable all lsp servers above
for server, config in pairs(servers) do
	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end
-- LSP attach keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local function lmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
		end

		lmap("K", vim.lsp.buf.hover, "Hover documentation")
		lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
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

		vim.lsp.inlay_hint.enable(false)
		lmap("<leader>lI", function()
			local enabled = not vim.lsp.inlay_hint.is_enabled({})
			vim.lsp.inlay_hint.enable(enabled)
			vim.notify("Inlay hints: " .. (enabled and " on" or "off"))
		end, "Toggle inlay hints")
	end,
})
