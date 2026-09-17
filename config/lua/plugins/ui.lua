local map = vim.keymap.set

-- ── buffer navigation ─────────────────────────────────────────────────
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
-- Bufferline used these for reordering; mini.tabline doesn't reorder, so keep as navigation.
map("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bmn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bmp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- ── pinning + close helpers (keeps old keybinds) ──────────────────────
local function pins()
	local p = vim.g.pinned_buffers
	if type(p) ~= "table" then p = {} end
	return p
end

local function listed_buffers()
	local res = {}
	for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
		table.insert(res, b.bufnr)
	end
	table.sort(res)
	return res
end

local function del(bufnr)
	if bufnr == nil or bufnr == 0 then
		return
	end
	pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
end

map("n", "<leader>bp", function()
	local b = vim.api.nvim_get_current_buf()
	local p = pins()
	local key = tostring(b)
	if p[key] then p[key] = nil else p[key] = true end
	vim.g.pinned_buffers = p
	vim.cmd.redrawtabline()
	vim.cmd.redrawstatus()
end, { desc = "Toggle pin buffer" })

map("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
	vim.cmd.redrawtabline()
	vim.cmd.redrawstatus()
end, { desc = "Delete buffer" })

map("n", "<leader>bD", function()
	require("mini.bufremove").delete(0, true)
	vim.cmd.redrawtabline()
	vim.cmd.redrawstatus()
end, { desc = "Delete buffer (force)" })

map("n", "<leader>bP", function()
	local cur = vim.api.nvim_get_current_buf()
	local p = pins()
	for _, b in ipairs(listed_buffers()) do
		if b ~= cur and not p[tostring(b)] then
			del(b)
		end
	end
end, { desc = "Close non-pinned buffers" })

map("n", "<leader>bo", function()
	local cur = vim.api.nvim_get_current_buf()
	for _, b in ipairs(listed_buffers()) do
		if b ~= cur then
			del(b)
		end
	end
end, { desc = "Close other buffers" })

map("n", "<leader>br", function()
	local cur = vim.api.nvim_get_current_buf()
	local bufs = listed_buffers()
	local idx
	for i, b in ipairs(bufs) do
		if b == cur then
			idx = i
			break
		end
	end
	if idx == nil then
		return
	end
	local p = pins()
	for i = idx + 1, #bufs do
		local b = bufs[i]
		if not p[tostring(b)] then
			del(b)
		end
	end
end, { desc = "Close buffers to the right" })

map("n", "<leader>bl", function()
	local cur = vim.api.nvim_get_current_buf()
	local bufs = listed_buffers()
	local idx
	for i, b in ipairs(bufs) do
		if b == cur then
			idx = i
			break
		end
	end
	if idx == nil then
		return
	end
	local p = pins()
	for i = 1, idx - 1 do
		local b = bufs[i]
		if not p[tostring(b)] then
			del(b)
		end
	end
end, { desc = "Close buffers to the left" })
