-- mini.nvim modules

-- Icons: used by mini.pick/tabline/etc.
require("mini.icons").setup()

-- ── mini.pairs ────────────────────────────────────────────────────────
require("mini.pairs").setup({
	modes = { insert = true, command = false, terminal = false },
})

-- ── mini.surround ─────────────────────────────────────────────────────
require("mini.surround").setup({
	mappings = {
		add = "gsa",
		delete = "gsd",
		find = "gsf",
		find_left = "gsF",
		highlight = "gsh",
		replace = "gsr",
		update_n_lines = "gsn",
	},
})

-- ── mini.jump2d (flash replacement) ───────────────────────────────────
require("mini.jump2d").setup({
	mappings = { start_jumping = "" }, -- we'll provide our own `s`/`S` maps
})

vim.keymap.set("n", "s", function()
	MiniJump2d.start()
end, { desc = "Jump" })
vim.keymap.set("n", "S", function()
	MiniJump2d.start(MiniJump2d.builtin_opts.word_start)
end, { desc = "Jump (word start)" })

-- ── mini.cursorword (illuminate replacement) ──────────────────────────
require("mini.cursorword").setup()

-- ── mini.bufremove (buffer delete without wrecking windows) ────────────
require("mini.bufremove").setup()

-- ── mini.hipatterns (color + TODO highlights) ─────────────────────────
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
		todo_TODO = { pattern = "%f[%w]TODO%f[%W]", group = "Todo" },
		todo_FIXME = { pattern = "%f[%w]FIXME%f[%W]", group = "Todo" },
		todo_HACK = { pattern = "%f[%w]HACK%f[%W]", group = "Todo" },
		todo_WARN = { pattern = "%f[%w]WARN%f[%W]", group = "Todo" },
		todo_NOTE = { pattern = "%f[%w]NOTE%f[%W]", group = "Todo" },
		todo_BUG = { pattern = "%f[%w]BUG%f[%W]", group = "Todo" },
	},
})

-- ── mini.diff (gitsigns replacement) ──────────────────────────────────
require("mini.diff").setup({
	mappings = {
		goto_prev = "[h",
		goto_next = "]h",
	},
})

-- ── mini.tabline (bufferline replacement) ─────────────────────────────
-- Minimal pin support is implemented via keymaps in `plugins/ui.lua`.
require("mini.tabline").setup({
	format = function(buf_id, label)
		local pins = vim.g.pinned_buffers
		local is_pinned = type(pins) == "table" and (pins[tostring(buf_id)] or pins[buf_id])
		if is_pinned then label = "󰐃 " .. label end
		return MiniTabline.default_format(buf_id, label)
	end,
})

-- ── mini.clue (which-key replacement) ─────────────────────────────────
local miniclue = require("mini.clue")
miniclue.setup({
	window = {
		delay = 0,
	},
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "z" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "x", keys = "[" },
		{ mode = "x", keys = "]" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = "n", keys = "<C-w>" },
	},
	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),

		{ mode = "n", keys = "<leader>b", desc = "+buffers" },
		{ mode = "n", keys = "<leader>c", desc = "+code" },
		{ mode = "n", keys = "<leader>e", desc = "Yazi" },
		{ mode = "n", keys = "<leader>E", desc = "Yazi cwd" },
		{ mode = "n", keys = "<leader>f", desc = "+find" },
		{ mode = "n", keys = "<leader>g", desc = "+git" },
		{ mode = "n", keys = "<leader>l", desc = "+lsp" },
		{ mode = "n", keys = "<leader>p", desc = "+yanky" },
		{ mode = "n", keys = "<leader>q", desc = "+quickfix/session" },
		{ mode = "n", keys = "<leader>s", desc = "+search" },
		{ mode = "n", keys = "<leader>u", desc = "+ui" },
		{ mode = "n", keys = "<leader>w", desc = "+window" },
		{ mode = "n", keys = "<leader>x", desc = "+diagnostics" },
	},
})

-- ── mini.pick + mini.extra ────────────────────────────────────────────
require("mini.pick").setup({
	mappings = {
		-- We'll keep an always-on side preview; disable the built-in preview view
		-- which replaces the match list.
		toggle_preview = "",
	},
	window = {
		config = function()
			local height = math.floor(0.618 * vim.o.lines)
			local width = math.floor(0.46 * vim.o.columns)
			local gap = 2
			local total = (2 * width) + gap
			return {
				relative = "editor",
				anchor = "NW",
				height = height,
				width = width,
				row = math.floor(0.5 * (vim.o.lines - height)),
				col = math.floor(0.5 * (vim.o.columns - total)),
				border = "rounded",
			}
		end,
	},
})

require("mini.extra").setup() -- registers extra pickers into :Pick

-- Always-on side preview for mini.pick (list + preview at the same time)
do
	local aug = vim.api.nvim_create_augroup("nvim_min_minipick_side_preview", { clear = true })

	local function close_preview(main_buf)
		if main_buf == nil or main_buf == 0 then
			return
		end
		local win = vim.b[main_buf].nvim_min_minipick_preview_win
		local buf = vim.b[main_buf].nvim_min_minipick_preview_buf
		vim.b[main_buf].nvim_min_minipick_preview_win = nil
		vim.b[main_buf].nvim_min_minipick_preview_buf = nil
		if type(win) == "number" and vim.api.nvim_win_is_valid(win) then
			pcall(vim.api.nvim_win_close, win, true)
		end
		if type(buf) == "number" and vim.api.nvim_buf_is_valid(buf) then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end

	local function render_preview(main_buf)
		local pick = require("mini.pick")
		if not pick.is_picker_active() then
			return
		end
		local win = vim.b[main_buf].nvim_min_minipick_preview_win
		local buf = vim.b[main_buf].nvim_min_minipick_preview_buf
		if type(win) ~= "number" or not vim.api.nvim_win_is_valid(win) then
			return
		end
		if type(buf) ~= "number" or not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local matches = pick.get_picker_matches()
		local cur = matches and matches.current or nil
		if cur == nil then
			return
		end
		pick.default_preview(buf, cur, { line_position = "top" })
	end

	vim.api.nvim_create_autocmd("User", {
		group = aug,
		pattern = "MiniPickStart",
		callback = function()
			local pick = require("mini.pick")
			local st = pick.get_picker_state()
			if st == nil then
				return
			end

			local main_win = st.windows.main
			local main_buf = st.buffers.main
			if main_win == nil or main_buf == nil then
				return
			end
			if not vim.api.nvim_win_is_valid(main_win) or not vim.api.nvim_buf_is_valid(main_buf) then
				return
			end

			close_preview(main_buf)

			local cfg = vim.api.nvim_win_get_config(main_win)
			if cfg.relative ~= "editor" then
				return
			end

			local col = tonumber(type(cfg.col) == "number" and cfg.col or cfg.col[false]) or 0
			local row = tonumber(type(cfg.row) == "number" and cfg.row or cfg.row[false]) or 0

			local gap = 2
			local preview_col = col + cfg.width + gap
			local preview_width = math.min(cfg.width, vim.o.columns - preview_col - 2)
			if preview_width < 20 then
				return
			end

			local pbuf = vim.api.nvim_create_buf(false, true)
			vim.bo[pbuf].bufhidden = "wipe"

			local pwin = vim.api.nvim_open_win(pbuf, false, {
				relative = "editor",
				anchor = "NW",
				row = row,
				col = preview_col,
				width = preview_width,
				height = cfg.height,
				border = "rounded",
				style = "minimal",
				zindex = (cfg.zindex or 251) - 1,
			})

			vim.api.nvim_set_option_value(
				"winhl",
				"NormalFloat:MiniPickNormal,FloatBorder:MiniPickBorder",
				{ scope = "local", win = pwin }
			)
			vim.wo[pwin].wrap = false
			vim.wo[pwin].signcolumn = "no"

			vim.b[main_buf].nvim_min_minipick_preview_win = pwin
			vim.b[main_buf].nvim_min_minipick_preview_buf = pbuf

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = aug,
				buffer = main_buf,
				callback = function()
					render_preview(main_buf)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				group = aug,
				pattern = "MiniPickStop",
				once = true,
				callback = function()
					close_preview(main_buf)
				end,
			})

			vim.schedule(function()
				render_preview(main_buf)
			end)
		end,
	})
end

-- ── mini.pick: keymaps + custom pickers ───────────────────────────────
do
	local map = vim.keymap.set
	local pick = require("mini.pick").builtin
	local extra = require("mini.extra").pickers

	local function pick_files()
		pick.files({ cwd = vim.uv.cwd() })
	end

	local function pick_buffers_pinned()
		local buffers_output = vim.api.nvim_exec("buffers", true)
		local pins = type(vim.g.pinned_buffers) == "table" and vim.g.pinned_buffers or {}

		local items = {}
		for _, l in ipairs(vim.split(buffers_output, "\n")) do
			local buf_str, name = l:match("^%s*%d+"), l:match('"(.*)"')
			local buf_id = tonumber(buf_str)
			if buf_id ~= nil then
				local pin = (pins[tostring(buf_id)] or pins[buf_id]) and "󰐃 " or "  "
				table.insert(items, { text = pin .. (name or ""), path = name, bufnr = buf_id })
			end
		end

		local MiniPick = require("mini.pick")
		MiniPick.start({
			source = {
				name = "Buffers",
				items = items,
				show = function(buf_id, its, query)
					MiniPick.default_show(buf_id, its, query, { show_icons = true })
				end,
			},
		})
	end

	local function visual_selection()
		local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
		return table.concat(lines, "\n")
	end

	local todo_pattern = "\\b(TODO|FIXME|HACK|WARN|NOTE|BUG)\\b"
	local function pick_todos()
		pick.grep({ pattern = todo_pattern })
	end

	local function pick_word()
		pick.grep({ pattern = vim.fn.expand("<cword>"), method = "plain" })
	end

	-- files / buffers
	map("n", "<leader><leader>", pick_files, { desc = "Find Files" })
	map("n", "<leader><space>", pick_files, { desc = "Find Files" })
	map("n", "<leader>f", pick_files, { desc = "Find Files" })
	map("n", "<leader>ff", pick_files, { desc = "Find Files" })
	map("n", "<leader>fc", function() pick.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
	map("n", "<leader>'", pick_buffers_pinned, { desc = "Buffers" })
	map("n", "<leader>fb", pick_buffers_pinned, { desc = "Buffers" })
	map("n", "<leader>fr", function() extra.oldfiles() end, { desc = "Recent" })
	map("n", "<leader>fg", function() extra.git_files() end, { desc = "Find Git Files" })

	-- extra `<leader>f*` aliases (old ~/nvim-min set); `fg` is taken by git files above
	map("n", "<leader>fG", function() pick.grep_live({ cwd = vim.uv.cwd() }) end, { desc = "Grep live" })
	map("n", "<leader>fd", function() extra.diagnostic({ scope = "all" }) end, { desc = "Find diagnostics" })
	map("n", "<leader>fo", function() extra.oldfiles() end, { desc = "Find old files" })
	map("n", "<leader>fh", function() extra.git_hunks() end, { desc = "Find git hunks" })
	map("n", "<leader>ft", pick_todos, { desc = "Find TODO/FIXME" })

	-- grep / search
	map("n", "<leader>/", function() pick.grep_live({ cwd = vim.uv.cwd() }) end, { desc = "Grep live" })
	map("v", "<leader>/", function() pick.grep({ pattern = visual_selection(), cwd = vim.uv.cwd() }) end, { desc = "Grep selection" })
	map("n", "<leader>sg", function() pick.grep({ cwd = vim.uv.cwd() }) end, { desc = "Grep" })
	map({ "n", "x" }, "<leader>sw", pick_word, { desc = "Word/Selection" })
	map("n", "<leader>s/", function() extra.history({ scope = "/" }) end, { desc = "Search History" })
	map("n", "<leader>:", function() extra.history({ scope = ":" }) end, { desc = "Command History" })
	map("n", "<leader>sc", function() extra.history({ scope = ":" }) end, { desc = "Command History" })

	-- misc pickers
	map("n", "<leader>sb", function() extra.buf_lines({ scope = "all" }) end, { desc = "Buffer Lines" })
	map("n", "<leader>sd", function() extra.diagnostic({ scope = "all" }) end, { desc = "Diagnostics" })
	map("n", "<leader>sh", function() pick.help() end, { desc = "Help Pages" })
	map("n", "<leader>sk", function() extra.keymaps() end, { desc = "Keymaps" })
	map("n", "<leader>sm", function() extra.marks() end, { desc = "Marks" })
	map("n", "<leader>sq", function() extra.list({ scope = "quickfix" }) end, { desc = "Quickfix List" })
	map("n", "<leader>sR", function() pick.resume() end, { desc = "Resume" })
	map("n", "<leader>st", pick_todos, { desc = "Todo" })

	-- LSP pickers
	map("n", "<leader>ss", function() extra.lsp({ scope = "document_symbol" }) end, { desc = "LSP Symbols" })
	map("n", "<leader>sS", function() extra.lsp({ scope = "workspace_symbol" }) end, { desc = "LSP Workspace Symbols" })
	map("n", "gd", function() extra.lsp({ scope = "definition" }) end, { desc = "Goto Definition" })
	map("n", "gD", function() extra.lsp({ scope = "declaration" }) end, { desc = "Goto Declaration" })
	map("n", "gr", function() extra.lsp({ scope = "references" }) end, { desc = "References", nowait = true })
	map("n", "gI", function() extra.lsp({ scope = "implementation" }) end, { desc = "Goto Implementation" })
	map("n", "gy", function() extra.lsp({ scope = "type_definition" }) end, { desc = "Goto Type Definition" })

	-- expose as `:Pick in_todo`
	_G.MiniPick.registry.in_todo = pick_todos
end
