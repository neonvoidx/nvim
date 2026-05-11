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
