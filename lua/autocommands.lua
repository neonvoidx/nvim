local autocmd = vim.api.nvim_create_autocmd

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	desc = "Check if we need to reload the file when it changed",
	command = "checktime",
})

autocmd("VimResized", {
	desc = "On terminal resize, resize splits",
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	desc = "make it easier to close man-files when opened inline",
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})

autocmd("FileType", {
	desc = "q to quick close specific filetypes",
	pattern = {
		"help",
		"lspinfo",
		"checkhealth",
		"qf",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.env", ".env.*" },
	desc = "Set filetype for .env and .env.* files",
	callback = function()
		vim.opt_local.filetype = "sh"
	end,
})

autocmd("FileType", {
	desc = "Autowrap lines in specific filetypes",
	pattern = { "gitcommit", "markdown", "trouble" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

autocmd("FileType", {
	desc = "Turn on spelling in specific filetypes",
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

autocmd("BufWritePre", {
	desc = "Autocreate directories when saving files if needed",
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

autocmd("InsertEnter", {
	desc = "Turn on absolute line numbers on insert",
	pattern = "*",
	callback = function()
		local ignore = { oil = true, fzf = true }
		if ignore[vim.bo.filetype] then
			return
		end
		vim.wo.relativenumber = false
	end,
})

autocmd("InsertLeave", {
	desc = "Turn on relative line numbers on normal mode",
	pattern = "*",
	callback = function()
		local ignore = { oil = true, fzf = true }
		if ignore[vim.bo.filetype] then
			return
		end
		vim.wo.relativenumber = true
	end,
})

autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd("BufReadPre", {
	desc = "Remember last location",
	callback = function(args)
		autocmd("FileType", {
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

local cmdline_completion_state = nil

autocmd("CmdlineEnter", {
	desc = "Enable popup completion for search cmdline",
	pattern = { "/", "?" },
	callback = function()
		cmdline_completion_state = {
			wildmode = vim.o.wildmode,
			wildoptions = vim.o.wildoptions,
		}

		vim.opt.wildmode = "noselect:lastused,full"
		vim.opt.wildoptions = "pum"
	end,
})

autocmd("CmdlineLeave", {
	desc = "Restore cmdline completion settings",
	pattern = { "/", "?" },
	callback = function()
		if not cmdline_completion_state then
			return
		end
		vim.opt.wildmode = cmdline_completion_state.wildmode
		vim.opt.wildoptions = cmdline_completion_state.wildoptions
		cmdline_completion_state = nil
	end,
})
