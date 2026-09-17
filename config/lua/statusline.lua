-- Native statusline (no plugin): designed around eldritch's palette.
local M = {}

local augroup = vim.api.nvim_create_augroup("nvim_min_statusline", { clear = true })

local function esc(s)
	s = tostring(s or "")
	return (s:gsub("%%", "%%%%"):gsub("\n", " "))
end

local function palette()
	local ok, colors = pcall(require, "eldritch.colors")
	if ok and type(colors) == "table" and type(colors.default) == "table" then
		return colors.default
	end
	-- Fallback: keep it readable even if colorscheme is not available.
	return {
		bg = "#212337",
		bg_highlight = "#292e42",
		fg = "#ebfafa",
		fg_dark = "#ABB4DA",
		cyan = "#04d1f9",
		magenta = "#a48cf2",
		orange = "#f7c67f",
		green = "#37f499",
		red = "#f16c75",
		yellow = "#f1fc79",
		comment = "#7081d0",
	}
end

local function apply_highlights()
	local c = palette()
	local set = vim.api.nvim_set_hl

	-- Base
	-- Use the theme's base background for the statusline.
	set(0, "NvimMinStlBase", { fg = c.fg_dark, bg = c.bg })
	set(0, "NvimMinStlDim", { fg = c.comment, bg = c.bg })

	-- Ensure native statusline uses our base background
	set(0, "StatusLine", { link = "NvimMinStlBase" })
	set(0, "StatusLineNC", { link = "NvimMinStlDim" })

	-- Mode blocks
	set(0, "NvimMinStlModeNormal", { fg = c.bg, bg = c.cyan, bold = true })
	set(0, "NvimMinStlModeInsert", { fg = c.bg, bg = c.green, bold = true })
	set(0, "NvimMinStlModeVisual", { fg = c.bg, bg = c.magenta, bold = true })
	set(0, "NvimMinStlModeReplace", { fg = c.bg, bg = c.red, bold = true })
	set(0, "NvimMinStlModeCommand", { fg = c.bg, bg = c.orange, bold = true })

	-- Solid blocks (no pills)
	-- Segment blocks should use theme background (`bg`) per preference.
	set(0, "NvimMinStlBlockGit", { fg = c.yellow, bg = c.bg, bold = true })
	set(0, "NvimMinStlBlockFile", { fg = c.fg, bg = c.bg })
	set(0, "NvimMinStlBlockLsp", { fg = c.cyan, bg = c.bg })
	set(0, "NvimMinStlBlockPos", { fg = c.fg_dark, bg = c.bg })

	-- Diagnostics
	set(0, "NvimMinStlDiagError", { fg = c.red, bg = c.bg, bold = true })
	set(0, "NvimMinStlDiagWarn", { fg = c.orange, bg = c.bg, bold = true })
	set(0, "NvimMinStlDiagInfo", { fg = c.cyan, bg = c.bg, bold = true })
	set(0, "NvimMinStlDiagHint", { fg = c.green, bg = c.bg, bold = true })
end

local function block(hl, content)
	if content == nil or content == "" then
		return ""
	end
	return "%#" .. hl .. "# " .. content .. " %#NvimMinStlBase#"
end

local function gap()
	return "%#NvimMinStlBase# "
end

local mode_map = {
	n = { letter = "N", icon = "󰘧", hl = "NvimMinStlModeNormal" },
	i = { letter = "I", icon = "󰏭", hl = "NvimMinStlModeInsert" },
	v = { letter = "V", icon = "󰸱", hl = "NvimMinStlModeVisual" },
	V = { letter = "V", icon = "󰸱", hl = "NvimMinStlModeVisual" },
	["\22"] = { letter = "V", icon = "󰸱", hl = "NvimMinStlModeVisual" },
	R = { letter = "R", icon = "", hl = "NvimMinStlModeReplace" },
	c = { letter = "C", icon = "", hl = "NvimMinStlModeCommand" },
	t = { letter = "C", icon = "", hl = "NvimMinStlModeCommand" },
}

local function mode_data(mode)
	mode = mode or vim.api.nvim_get_mode().mode
	local m = mode:sub(1, 1)
	return mode_map[m] or mode_map.n
end

local ft_lang = {
	lua = { icon = "", name = "Lua" },
	nix = { icon = "", name = "Nix" },
	zig = { icon = "", name = "Zig" },
	rust = { icon = "", name = "Rust" },
	go = { icon = "", name = "Go" },
	c = { icon = "", name = "C" },
	cpp = { icon = "", name = "C++" },
	objc = { icon = "", name = "ObjC" },
	objcpp = { icon = "", name = "ObjC++" },
	python = { icon = "", name = "Python" },
	javascript = { icon = "", name = "JavaScript" },
	javascriptreact = { icon = "", name = "JSX" },
	typescript = { icon = "", name = "TypeScript" },
	typescriptreact = { icon = "", name = "TSX" },
	yaml = { icon = "", name = "YAML" },
	sh = { icon = "", name = "Shell" },
	bash = { icon = "", name = "Bash" },
	zsh = { icon = "", name = "Zsh" },
	markdown = { icon = "", name = "Markdown" },
}

local git_cache = {}

local function git_root(path)
	local start = path ~= "" and vim.fs.dirname(path) or vim.uv.cwd()
	local hit = vim.fs.find(".git", { path = start, upward = true })[1]
	return hit and vim.fs.dirname(hit) or nil
end

local function git_refresh(root)
	local e = git_cache[root] or { running = false, ts = 0, branch = nil }
	if e.running then
		return
	end
	e.running = true
	git_cache[root] = e

	vim.system({ "git", "-C", root, "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }, function(res)
		e.running = false
		e.ts = vim.uv.now()
		if res.code == 0 then
			local b = vim.trim(res.stdout or "")
			if b == "HEAD" then
				local r2 = vim.system({ "git", "-C", root, "rev-parse", "--short", "HEAD" }, { text = true }):wait()
				if r2 and r2.code == 0 then
					b = vim.trim(r2.stdout or "")
				end
			end
			e.branch = b
		end
		vim.schedule(function()
			vim.cmd("redrawstatus")
		end)
	end)
end

local function git_branch(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local root = git_root(name)
	if root == nil then
		return nil
	end

	local e = git_cache[root]
	local now = vim.uv.now()
	if e == nil or ((now - (e.ts or 0)) > 2000 and not e.running) then
		git_refresh(root)
	end
	return e and e.branch or nil
end

local function diagnostics_segment(bufnr)
	local counts = vim.diagnostic.count(bufnr)
	if type(counts) ~= "table" then
		return ""
	end

	local sev = vim.diagnostic.severity
	local nerr = counts[sev.ERROR] or 0
	local nwarn = counts[sev.WARN] or 0
	local ninfo = counts[sev.INFO] or 0
	local nhint = counts[sev.HINT] or 0
	if (nerr + nwarn + ninfo + nhint) == 0 then
		return ""
	end

	local parts = {}
	-- No pills for diagnostics (per preference), just colored icons.
	if nerr > 0 then
		table.insert(parts, "%#NvimMinStlDiagError#" .. nerr .. " ")
	end
	if nwarn > 0 then
		table.insert(parts, "%#NvimMinStlDiagWarn#" .. nwarn .. " ")
	end
	if ninfo > 0 then
		table.insert(parts, "%#NvimMinStlDiagInfo#" .. ninfo .. " ")
	end
	if nhint > 0 then
		table.insert(parts, "%#NvimMinStlDiagHint#󰌵" .. nhint .. " ")
	end
	return "%#NvimMinStlBase#" .. table.concat(parts, "")
end

local function lsp_segment(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		return ""
	end

	local ft = vim.bo[bufnr].filetype
	local lang = ft_lang[ft]
	local icon = lang and lang.icon or "󰒋"

	local seen, names = {}, {}
	for _, c in ipairs(clients) do
		if type(c.name) == "string" and c.name ~= "" and not seen[c.name] then
			seen[c.name] = true
			table.insert(names, c.name)
		end
	end
	table.sort(names)
	if #names == 0 then
		return ""
	end

	return block("NvimMinStlBlockLsp", icon .. " " .. esc(table.concat(names, ",")))
end

local function file_segment(winid, bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local rel = name ~= "" and vim.fn.fnamemodify(name, ":.") or "[No Name]"
	rel = esc(rel)

	local flags = ""
	if vim.bo[bufnr].modified then
		flags = flags .. " +"
	end
	if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
		flags = flags .. " "
	end

	-- Mark truncation point before the filename.
	return block("NvimMinStlBlockFile", "%<" .. rel .. flags)
end

local function pos_segment(winid, bufnr)
	local cur = vim.api.nvim_win_get_cursor(winid)
	local line, col = cur[1], cur[2] + 1
	local total = vim.api.nvim_buf_line_count(bufnr)
	local pct = total > 0 and math.floor((line / total) * 100) or 0
	return block("NvimMinStlBlockPos", string.format("%d:%d  %d%%%%", line, col, pct))
end

function M.render()
	local winid = vim.g.statusline_winid or 0
	if winid == 0 or not vim.api.nvim_win_is_valid(winid) then
		return ""
	end
	local bufnr = vim.api.nvim_win_get_buf(winid)

	local md = mode_data()
	local left = {}
	table.insert(left, block(md.hl, md.letter))

	local branch = git_branch(bufnr)
	if type(branch) == "string" and branch ~= "" then
		table.insert(left, block("NvimMinStlBlockGit", " " .. esc(branch)))
	end

	table.insert(left, file_segment(winid, bufnr))

	local middle = diagnostics_segment(bufnr)

	local right = {}
	local lsp = lsp_segment(bufnr)
	local pos = pos_segment(winid, bufnr)
	if lsp ~= "" then
		table.insert(right, lsp)
	end
	if lsp ~= "" and pos ~= "" then
		table.insert(right, gap())
	end
	if pos ~= "" then
		table.insert(right, pos)
	end

	return table.concat(left, "") .. "%=" .. middle .. "%=" .. table.concat(right, "")
end

function M.setup()
	vim.o.statusline = "%!v:lua.require'statusline'.render()"

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = apply_highlights,
	})
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		callback = apply_highlights,
	})
end

return M
