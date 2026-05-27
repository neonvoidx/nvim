local servers = {
  basedpyright = {},
  clangd = {},
  gopls = {},
  nixd = {
    nixpkgs = {
      expr = "import <nixpkgs> { }",
    },
    formatting = {
      command = { "nixfmt" },
    },
  },
  rust_analyzer = {},
  yamlls = {},
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
  },
  vtsls = {
    settings = {
      complete_function_calls = true,
      vtsls = {
        enableMoveToFileCodeAction = true,
        autoUseWorkspaceTsdk = true,
        experimental = { maxInlayHintLength = 30, completion = { enableServerSideFuzzyMatch = true } },
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
  },
}
-- Enable inlay hints globally before LSP starts
vim.lsp.inlay_hint.enable(true)

for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    local function lmap(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end
    lmap("K", vim.lsp.buf.hover, "Hover documentation")
    lmap("gD", vim.lsp.buf.declaration, "Go to declaration")
    lmap("gd", vim.lsp.buf.definition, "Go to definition")
    lmap("gr", vim.lsp.buf.references, "References")
    lmap("gi", vim.lsp.buf.implementation, "Go to implementation")
    lmap("gy", vim.lsp.buf.type_definition, "Go to type definition")
    lmap("gK", vim.lsp.buf.signature_help, "Signature help")
    lmap("[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")
    lmap("]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")
    lmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
    lmap("<leader>cA", function()
      vim.lsp.buf.code_action({ apply = true, context = { only = { "source" }, diagnostics = {} } })
    end, "Code action (buffer)")
    lmap("<leader>cs", vim.lsp.buf.document_symbol, "Document symbols")
    lmap("<leader>cS", vim.lsp.buf.workspace_symbol, "Workspace symbols")
    lmap("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
    lmap("<leader>li", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
    lmap("<leader>ll", function()
      vim.cmd("edit " .. vim.lsp.log.get_filename())
    end, "LSP Logs")
    lmap("<leader>lr", "<cmd>LspRestart<cr>", "LSP Restart")
    lmap("<leader>lI", function()
      local enabled = not vim.lsp.inlay_hint.is_enabled({})
      vim.lsp.inlay_hint.enable(enabled)
      vim.g.inlay_hints_manually_disabled = not enabled
      vim.notify("Inlay hints: " .. (enabled and " on" or "off"))
    end, "Toggle inlay hints")
  end,
})
