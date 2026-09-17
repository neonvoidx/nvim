-- Formatting (conform) + linting (nvim-lint)
require("conform").setup({
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
		jsonc = { "prettierd" },
		yaml = { "prettierd" },
		markdown = { "prettierd" },
		lua = { "stylua" },
		python = { "isort", "black" },
		nix = { "nixfmt" },
	},
	formatters = { prettierd = { require_cwd = true } },
	notify_on_error = false,
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_format = "fallback", notify_on_error = false }
	end,
})

vim.g.disable_autoformat = false

vim.keymap.set("n", "<leader>cf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify(
		"Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"),
		vim.log.levels.INFO,
		{ title = "Conform" }
	)
end, { desc = "Toggle autoformat" })

vim.keymap.set("n", "<leader>cF", function()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat
	vim.notify(
		"Autoformat " .. (vim.b[bufnr].disable_autoformat and "disabled" or "enabled") .. " (buffer)",
		vim.log.levels.INFO,
		{ title = "Conform" }
	)
end, { desc = "Toggle autoformat (buffer)" })

-- ── nvim-lint ─────────────────────────────────────────────────────────
local has_eslint_d = vim.fn.executable("eslint_d") == 1
if has_eslint_d then
	vim.env.ESLINT_D_PPID = vim.fn.getpid()
end

local linters_by_ft = {
	cmake = { "cmakelint" },
}
if has_eslint_d then
	linters_by_ft.typescript = { "eslint_d" }
	linters_by_ft.typescriptreact = { "eslint_d" }
	linters_by_ft.javascript = { "eslint_d" }
	linters_by_ft.javascriptreact = { "eslint_d" }
	linters_by_ft["javascript.jsx"] = { "eslint_d" }
	linters_by_ft["typescript.tsx"] = { "eslint_d" }
end

require("lint").linters_by_ft = linters_by_ft

local lint_group = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_group,
	callback = function()
		require("lint").try_lint()
	end,
})
