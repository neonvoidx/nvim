local function augroup(name)
	return vim.api.nvim_create_augroup("autocmd_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].autocmd_last_loc then
			return
		end
		vim.b[buf].autocmd_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"help",
		"lspinfo",
		"checkhealth",
		"qf",
		"grug-far",
	},
	callback = function(event)
		vim.keymap.set("n", "q", function()
			vim.cmd("close")
		end, { buffer = event.buf, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_ft"),
	pattern = { "gitcommit", "markdown", "trouble" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("spell_ft"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

local numtog = augroup("NumberToggle")
vim.api.nvim_create_autocmd("InsertEnter", {
	group = numtog,
	pattern = "*",
	callback = function()
		local ignore = { oil = true, fzf = true }
		if ignore[vim.bo.filetype] then
			return
		end
		vim.wo.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = numtog,
	pattern = "*",
	callback = function()
		local ignore = { oil = true, fzf = true }
		if ignore[vim.bo.filetype] then
			return
		end
		vim.wo.relativenumber = true
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufReadPre", {
	group = augroup("RestoreCursor"),
	callback = function(args)
		vim.api.nvim_create_autocmd("FileType", {
			buffer = args.buf,
			once = true,
			callback = function()
				local ft = vim.bo[args.buf].filetype
				local last_pos = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
				local last_line = vim.api.nvim_buf_line_count(args.buf)
				if
					last_pos >= 1
					and last_pos <= last_line
					and not ft:match("commit")
					and not vim.tbl_contains({ "gitrebase", "nofile", "svn", "gitcommit" }, ft)
				then
					vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
				end
			end,
		})
	end,
})
