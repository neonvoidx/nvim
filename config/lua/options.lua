vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true
opt.autoread = true
-- Avoid startup errors in pure TTY sessions where a Wayland clipboard provider
-- might exist on PATH but no Wayland server is available.
do
	local uv = vim.uv or vim.loop
	local is_socket = function(path)
		local st = uv.fs_stat(path)
		return st ~= nil and st.type == 'socket'
	end

	local runtime = vim.env.XDG_RUNTIME_DIR
	local function pick_wayland_display()
		if runtime == nil or runtime == "" then return nil end
		local disp = vim.env.WAYLAND_DISPLAY
		if type(disp) == "string" and disp ~= "" and is_socket(runtime .. "/" .. disp) then return disp end
		-- If env points nowhere, try any existing wayland-* socket.
		local it = uv.fs_scandir(runtime)
		if it == nil then return nil end
		while true do
			local name = uv.fs_scandir_next(it)
			if name == nil then break end
			if name:match("^wayland%-%d+$") and is_socket(runtime .. "/" .. name) then return name end
		end
		return nil
	end

	local wl_display = pick_wayland_display()
	local has_wayland = wl_display ~= nil
	local has_x11 = function()
		local display = vim.env.DISPLAY
		if display == nil or display == "" then return false end
		local n = tonumber(display:match('^:(%d+)'))
		if n == nil then return false end
		return is_socket('/tmp/.X11-unix/X' .. n)
	end

	if has_wayland then
		-- If WAYLAND_DISPLAY was stale/wrong, fix it just for this process.
		vim.env.WAYLAND_DISPLAY = wl_display
		vim.g.clipboard = {
			name = "wl-clipboard",
			copy = { ['+'] = 'wl-copy', ['*'] = 'wl-copy' },
			paste = { ['+'] = 'wl-paste --no-newline', ['*'] = 'wl-paste --no-newline' },
			cache_enabled = 1,
		}
		opt.clipboard = "unnamedplus"
	elseif has_x11() then
		-- Force xclip even if WAYLAND_DISPLAY is set but unusable.
		vim.g.clipboard = {
			name = "xclip",
			copy = {
				['+'] = 'xclip -quiet -i -selection clipboard',
				['*'] = 'xclip -quiet -i -selection primary',
			},
			paste = {
				['+'] = 'xclip -o -selection clipboard',
				['*'] = 'xclip -o -selection primary',
			},
			cache_enabled = 1,
		}
		opt.clipboard = "unnamedplus"
	else
		opt.clipboard = ""
	end
end
opt.completeopt = { "menu", "menuone", "preselect" }
opt.completeopt:append("popup")
opt.conceallevel = 1
opt.confirm = true
opt.cmdheight = 0
opt.cursorline = true
opt.expandtab = true
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.list = false
opt.mouse = "nv"
opt.mousemoveevent = true
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = true
opt.scrolloff = 4
opt.shiftround = true
opt.shiftwidth = 2
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.softtabstop = 2
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
opt.smoothscroll = true
opt.shada = "!,'300,<50,s10,h"

-- Experimental native UI improvements (Neovim 0.12+).
pcall(function()
	require("vim._core.ui2").enable()
end)

opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.foldmethod = "expr" -- nvim-ufo sets foldexpr in its setup

-- Native builtin (0.13) autocompletion
vim.o.autocomplete = true

-- winborder is an -o (global) option, not exposed by vim.opt
vim.o.winborder = "rounded"

opt.sessionoptions = { "blank", "buffers", "curdir", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ a = true, A = true, W = true, I = true, c = true, C = true })
opt.spelllang = { "en" }

-- Per-project shada (source: ~/nvim)
do
	local cwd = vim.fn.getcwd()
	local git_dir = vim.fs.find(".git", { path = cwd, upward = true })[1]
	local root = git_dir and vim.fn.fnamemodify(git_dir, ":h") or cwd
	local shada_dir = vim.fn.stdpath("state") .. "/shada-projects"

	vim.fn.mkdir(shada_dir, "p")
	vim.opt.shadafile = shada_dir .. "/" .. vim.fn.sha256(root) .. ".shada"
end

opt.fillchars = {
	foldopen = "▾",
	foldclose = "▸",
	fold = " ",
	foldsep = "│",
	-- Without this, a 1-column foldcolumn is "too narrow" for nested folds and
	-- Neovim falls back to digits for the fold level. foldinner replaces that
	-- fallback with a clean vertical guide.
	foldinner = "│",
	diff = "╱",
	eob = " ",
}

vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✖",
			[vim.diagnostic.severity.WARN] = "⬤",
			[vim.diagnostic.severity.INFO] = "…",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	float = {
		border = "rounded",
		format = function(d)
			return ("%s (%s) [%s]"):format(
				d.message,
				d.source,
				d.code or (d.user_data.lsp and d.user_data.lsp.code) or ""
			)
		end,
	},
	underline = true,
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	},
})
