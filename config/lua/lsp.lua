local function async_root(markers, fallback)
	local function root_dir(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, markers) or (fallback and vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)) or nil))
	end
	return root_dir
end

-- Lua
vim.lsp.config("lua_language_server", {
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
			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = "all",
				arrayIndex = "auto",
			},
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "require" } },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
			telemetry = { enable = false },
		},
	},
})

-- TypeScript / JavaScript
vim.lsp.config("vtsls", {
	cmd = { "vtsls" },
	filetypes = {
		"typescript",
		"typescriptreact",
		"javascript",
		"javascriptreact",
		"typescript.tsx",
		"javascript.jsx",
	},
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	settings = {
		complete_function_calls = true,
		vtsls = {
			enableMoveToFileCodeAction = true,
			autoUseWorkspaceTsdk = true,
			experimental = {
				maxInlayHintLength = 30,
				completion = { enableServerSideFuzzyMatch = true },
			},
		},
		typescript = {
			updateImportsOnFileMove = { enabled = "always" },
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				enumMemberValues = { enabled = true },
				functionLikeReturnTypes = { enabled = true },
				parameterNames = { enabled = "literals" },
				parameterTypes = { enabled = true },
				propertyDeclarationTypes = { enabled = true },
				variableTypes = { enabled = false },
			},
			preferences = { importModuleSpecifier = "relative" },
		},
	},
})

-- Python
vim.lsp.config("basedpyright", {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"requirements.in",
		"tox.ini",
		"pyrightconfig.json",
		".git",
	},
})

-- Rust
vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".rust-toolchain.toml", "rust-toolchain.toml" },
})

-- Go
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_markers = { "go.mod", "go.work", ".git" },
})

-- C/C++
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
})

-- Bash
vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash", "zsh" },
	root_dir = async_root({ ".git", "package.json", ".bashrc", ".zshrc" }, true),
})

-- YAML
vim.lsp.config("yaml_language_server", {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml" },
	root_dir = async_root({ "yaml-language-server.yml", ".git" }, true),
})

-- Nix
vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_dir = async_root({ "flake.nix", "shell.nix", "default.nix", ".git" }, false),
	settings = {
		nixd = {
			nixpkgs = { expr = "import <nixpkgs> { }" },
			options = {
				["home-manager"] = {
					expr = '(import <home-manager/modules> { configuration = { home.username = "_"; home.homeDirectory = "/tmp"; home.stateVersion = "26.05"; }; pkgs = import <nixpkgs> {}; }).options',
				},
			},
		},
	},
})

-- Zig
vim.lsp.config("zls", {
	cmd = { "zls" },
	filetypes = { "zig" },
	root_markers = { "build.zig", "build.zig.zon", "zls.json", ".git" },
})

vim.lsp.enable({
	"lua_language_server",
	"vtsls",
	"basedpyright",
	"rust_analyzer",
	"gopls",
	"clangd",
	"yaml_language_server",
	"bashls",
	"nixd",
	"zls",
})

-- Arduino (manual wiring ported from ~/nvim)
vim.filetype.add({ extension = { ino = "arduino" } })
vim.lsp.config("arduino_language_server", {
	cmd = { "arduino-language-server", "-clangd", "clangd", "-cli", "arduino-cli" },
	filetypes = { "arduino" },
	root_dir = async_root({ "sketch.yaml", ".git" }, true),
})
vim.lsp.enable("arduino_language_server")

-- Inlay hints: on normally, off while inserting
vim.g.inlay_hints_manually_disabled = true
vim.lsp.inlay_hint.enable(false)

local inlay_hints_group = vim.api.nvim_create_augroup("InlayHintsInsert", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	group = inlay_hints_group,
	desc = "Disable inlay hints in insert mode",
	callback = function()
		vim.lsp.inlay_hint.enable(false)
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = inlay_hints_group,
	desc = "Re-enable inlay hints when leaving insert mode",
	callback = function()
		if not vim.g.inlay_hints_manually_disabled then
			vim.lsp.inlay_hint.enable(true)
		end
	end,
})

-- LspAttach keymaps (ported from ~/nvim)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local map = vim.keymap.set
		local opts = { buffer = ev.buf }
		local e = function(desc)
			return vim.tbl_extend("force", opts, { desc = desc })
		end

		map("n", "K", vim.lsp.buf.hover, e("Hover documentation"))
		map("n", "gK", vim.lsp.buf.signature_help, e("Signature help"))
		map("n", "gi", vim.lsp.buf.implementation, e("Go to implementation"))
		map("n", "<leader>ca", vim.lsp.buf.code_action, e("Code action (line)"))
		map("n", "<leader>cr", vim.lsp.buf.rename, e("Rename symbol"))
		map("n", "<leader>cA", function()
			vim.lsp.buf.code_action({
				apply = true,
				context = { only = { "source" }, diagnostics = {} },
			})
		end, e("Code action (buffer)"))
		map("n", "<leader>cs", vim.lsp.buf.document_symbol, e("Document symbols"))
		map("n", "<leader>cS", vim.lsp.buf.workspace_symbol, e("Workspace symbols"))
		map("n", "<leader>li", "<cmd>checkhealth lsp<cr>", e("LSP Info"))
		map("n", "<leader>ll", "<cmd>lua vim.cmd('e '..vim.lsp.get_log_path())<cr>", e("LSP Logs"))
		map("n", "<leader>lr", "<cmd>LspRestart<cr>", e("LSP Restart"))
		map("n", "<leader>lI", function()
			local enabled = not vim.lsp.inlay_hint.is_enabled({})
			vim.lsp.inlay_hint.enable(enabled)
			vim.g.inlay_hints_manually_disabled = not enabled
			vim.notify("Inlay hints: " .. (enabled and "on" or "off"))
		end, e("Toggle inlay hints"))
	end,
})
