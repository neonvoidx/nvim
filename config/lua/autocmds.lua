local function augroup(name)
	return vim.api.nvim_create_augroup("autocmd_" .. name, { clear = true })
end

-- Equalize splits after window resize
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- Jump to last cursor position when reopening a buffer
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

-- Close auxiliary filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"startuptime",
		"tsplayground",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Shell syntax for environment files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = augroup("env_filetype"),
	pattern = { "*.env", ".env.*" },
	callback = function()
		vim.opt_local.filetype = "sh"
	end,
})

-- Enable line wrap for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_ft"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
})

-- Enable spell checking for prose filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("spell_ft"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

-- Auto-create missing parent directories on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Relative line numbers: off in insert, on elsewhere
local numtog = augroup("NumberToggle")
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	group = numtog,
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "oil" then
			return
		end
		vim.wo.relativenumber = false
	end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	group = numtog,
	pattern = "*",
	callback = function()
		if vim.bo.filetype == "oil" then
			return
		end
		vim.wo.relativenumber = true
	end,
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  desc = "Highlight when yanking (copying) text",
  callback = function()
    -- 0.13+: use `vim.hl.hl_op` (avoids deprecated `vim.hl.on_yank`).
    pcall(vim.hl.hl_op, { higroup = "IncSearch", timeout = 150 })
  end,
})

-- Show the default :intro screen on empty startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("intro"),
  once = true,
  callback = function()
    if vim.fn.argc() ~= 0 then return end
    if vim.fn.getcmdwintype() ~= "" then return end
    if vim.api.nvim_buf_get_name(0) ~= "" then return end
    if vim.bo.buftype ~= "" then return end
    if vim.bo.modified then return end
    local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
    if #lines > 1 then return end
    if (lines[1] or "") ~= "" then return end
    vim.cmd.intro()
  end,
})
