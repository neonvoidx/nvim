local map = vim.keymap.set

-- jj and kk escape insert mode
map("i", "jj", "<Esc>")
map("i", "kk", "<Esc>")

-- Better jk
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window management
map("n", "<leader>wd", "<cmd>q<cr>", { desc = "Delete window", remap = true })
map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split right", remap = true })
map("n", "<leader>w-", "<cmd>split<cr>", { desc = "Split below", remap = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines and selections
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Escape to clear search highlight
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- redraw, clear highlights etc
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- Better search
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Better undo breakpoints
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- C-s to save
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Create new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- C-q to save all and quit
map("n", "<C-q>", "<cmd>silent! xa<cr>", { desc = "Save all and quit" })

-- Add comments below or above line
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Indenting visual selectiion
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Remap insert to escape
local esc_modes = { "i", "n", "v", "x", "o", "t", "s", "c", "l" }
map(esc_modes, "<Insert>", "<Esc>")

-- Nop unbinds
map(esc_modes, "<F1>", "<Nop>")
map(esc_modes, "<C-LeftMouse>", "<Nop>")
map("n", "<C-t>", "<Nop>")

-- Blackhole Delete
map({ "n", "v" }, "D", '"_d')

-- Blackhole Change
map({ "n", "v" }, "C", '"_c')

-- Visual selection, into search and replace
local function get_visual()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getpos(".")
	local ls, cs = start_pos[2], start_pos[3]
	local le, ce = end_pos[2], end_pos[3]
	if ls > le or (ls == le and cs > ce) then
		ls, le = le, ls
		cs, ce = ce, cs
	end
	return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end
map("v", "<C-r>", function()
	local pattern = table.concat(get_visual(), "\n")
	pattern = vim.fn.substitute(vim.fn.escape(pattern, "^$.*\\/~[]"), "\n", "\\n", "g")
	vim.cmd.normal({ bang = true, args = { "<Esc>" } })
	vim.fn.feedkeys(vim.api.nvim_replace_termcodes(":%s/" .. pattern .. "//g<Left><Left>", true, false, true), "n")
end, { desc = "Search and replace selection" })

-- Clipboard diff
local function compare_to_clip()
	local ftype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
	vim.cmd("vsplit")
	vim.cmd("enew")
	vim.cmd("normal! P")
	vim.opt_local.buftype = "nowrite"
	vim.opt_local.filetype = ftype
	vim.cmd("diffthis")
	vim.cmd([[execute "normal! \<C-w>h"]])
	vim.cmd("diffthis")
end
map("n", "<leader>D", compare_to_clip, { desc = "Diff vs clipboard" })

-- buffers
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bd<CR>>", { desc = "Delete buffer" })

-- Select all content
map("n", "==", "gg<S-v>G")
map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })

-- reload ui
map("n", "<leader>uR", "<cmd>restart<cr>", { desc = "Restart UI" })

-- Update plugins
map("n", "<leader>uu", function()
	vim.pack.update()
end, { desc = "Update plugins" })

-- Copy whole file to clipboard
map("n", "<C-c>", ":%y+<CR>", { noremap = true, silent = true })

-- auto close pairs
-- map("i", "'", "''<left>") -- commented out - smart!
map("i", "`", "``<left>")
map("i", '"', '""<left>')
map("i", "(", "()<left>")
map("i", "[", "[]<left>")
map("i", "{", "{}<left>")
map("i", "<", "<><left>")

-- Close all fold except the current one.
map("n", "zv", "zMzvzz", {
	desc = "Close all folds except the current one",
})

-- Close current fold when open. Always open next fold.
map("n", "zj", "zcjzOzz", {
	desc = "Close current fold when open. Always open next fold.",
})

-- Goto
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })

-- Quickfix and location lists
map("n", "<leader>xl", function()
	local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Location List" })
map("n", "<leader>xq", function()
	local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
	if not success and err then
		vim.notify(err, vim.log.levels.ERROR)
	end
end, { desc = "Quickfix List" })

-- Quickfix next/prev
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

local function open_lazygit_float()
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		border = "rounded",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
	})

	vim.fn.termopen("lazygit", {
		on_exit = function()
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
	vim.cmd.startinsert()
end

map("n", "<leader>gg", open_lazygit_float, { desc = "Open Lazygit" })

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

-- Inspection tools (useful for debugging highlights and treesitter)
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- messages
map("n", "<leader>nm", "<cmd>:message<cr>", { desc = "Message history" })
