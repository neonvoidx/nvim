local servers = {
	basedpyright = {},
	clangd = {},
	gopls = {},
	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = {
			".luarc.json",
			".luarc.jsonc",
			".luacheckrc",
			".stylua.toml",
			"stylua.toml",
			"selene.toml",
			"selene.yml",
			".git",
		},
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
			},
		},
	},
	["nil"] = {},
	rust_analyzer = {},
	yamlls = {},
	vtsls = {
		settings = {
			complete_function_calls = true,
			vtsls = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
				experimental = {
					maxInlayHintLength = 30,
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
			},
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = {
					completeFunctionCalls = true,
				},
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
				preferences = {
					importModuleSpecifier = "relative",
				},
			},
		},
	},
}

for server, config in pairs(servers) do
	vim.lsp.config(server, config)
	vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		-- Enable autocompletion (native)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
			})
		end

		local opts = { buffer = ev.buf }
		local function lmap(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
		end
		lmap("K", vim.lsp.buf.hover, "Hover documentation")
		lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
		lmap("<leader>cA", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = { only = { "source" }, diagnostics = {} },
			})
		end, "Code action (buffer)")
		lmap("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
		lmap("<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
		lmap("<leader>ll", function()
			vim.cmd("edit " .. vim.lsp.get_log_path())
		end, "LSP Logs")
		lmap("<leader>lr", "<cmd>LspRestart<cr>", "LSP Restart")

		vim.lsp.inlay_hint.enable(false)
		lmap("<leader>lI", function()
			local enabled = not vim.lsp.inlay_hint.is_enabled({})
			vim.lsp.inlay_hint.enable(enabled)
			vim.notify("Inlay hints: " .. (enabled and " on" or "off"))
		end, "Toggle inlay hints")
	end,
})
