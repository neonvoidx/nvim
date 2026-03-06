local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
  vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
  vim.keymap.set("n", "gI",         vim.lsp.buf.implementation,  vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
  vim.keymap.set("n", "gy",         vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Goto T[y]pe Definition" }))
  vim.keymap.set("n", "gr",         function() require("trouble").toggle("lsp_references") end, vim.tbl_extend("force", opts, { desc = "References" }))
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename,          vim.tbl_extend("force", opts, { desc = "Rename" }))
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
  vim.keymap.set("n", "K",          vim.lsp.buf.hover,           vim.tbl_extend("force", opts, { desc = "Hover" }))

  if client.supports_method("textDocument/inlayHint") then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

local capabilities = nil
local function get_capabilities()
  if not capabilities then
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
      capabilities = blink.get_lsp_capabilities()
    else
      capabilities = vim.lsp.protocol.make_client_capabilities()
    end
  end
  return capabilities
end

local function setup_lsp(server, cfg)
  cfg = cfg or {}
  cfg.on_attach = on_attach
  cfg.capabilities = vim.tbl_deep_extend("force", get_capabilities(), cfg.capabilities or {})
  require("lspconfig")[server].setup(cfg)
end

return {
  {
    "nvim-lspconfig",
    lazy = false,
    after = function()
      setup_lsp("bashls")
      setup_lsp("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      setup_lsp("gopls", {
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
          },
        },
      })
      setup_lsp("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            doc = { privateName = { "^_" } },
            type = { castNumberToInteger = true },
            diagnostics = { disable = { "incomplete-signature-doc", "trailing-space" } },
            hint = {
              enable = true,
              setType = false,
              paramType = true,
              paramName = "Disable",
              semicolon = "Disable",
              arrayIndex = "Disable",
            },
          },
        },
      })
      setup_lsp("basedpyright", {
        settings = {
          basedpyright = {
            analysis = { autoSearchPaths = true, autoImportCompletions = true },
          },
        },
      })
      setup_lsp("yamlls", {
        settings = {
          yaml = { schemaStore = { enable = false, url = "" } },
        },
      })
      setup_lsp("docker_compose_language_service")
      setup_lsp("dockerls")
      setup_lsp("neocmake")
      setup_lsp("vtsls", {
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = { completion = { enableServerSideFuzzyMatch = true } },
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
          },
        },
      })
      setup_lsp("terraformls")
      setup_lsp("emmet_language_server")
      -- Fish and typos-lsp only if available (not always in nixpkgs)
      pcall(setup_lsp, "fish_lsp")
      pcall(setup_lsp, "typos_lsp")
    end,
    keys = {
      { "<leader>Li", "<cmd>LspInfo<cr>",    desc = "LSP Info" },
      { "<leader>Ll", "<cmd>LspLog<cr>",     desc = "LSP Log" },
      { "<leader>Lr", "<cmd>LspRestart<cr>", desc = "LSP Restart" },
    },
  },
  {
    "vim-illuminate",
    lazy = false,
    after = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 200,
        filetypes_denylist = { "dirbuf", "dirvish", "fugitive" },
      })
    end,
  },
  {
    "trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
    },
    after = function()
      require("trouble").setup({
        modes = {
          lsp_references = {
            params = {
              include_declaration = true,
            },
          },
        },
      })
    end,
  },
  {
    "lazydev.nvim",
    ft = "lua",
    after = function()
      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      })
    end,
  },
  {
    "rustaceanvim",
    ft = "rust",
    beforeAll = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = on_attach,
          capabilities = get_capabilities(),
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
              checkOnSave = true,
              check = { command = "clippy", extraArgs = { "--all", "--", "-W", "clippy::pedantic" } },
              procMacro = { enable = true, ignored = { ["async-trait"] = { "async_trait" }, ["napi-derive"] = { "napi" }, ["async-recursion"] = { "async_recursion" } } },
            },
          },
        },
      }
    end,
  },
  {
    "clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    after = function()
      -- clangd uses a custom setup that returns false to avoid double-setup via lspconfig
      require("clangd_extensions").setup({
        server = {
          on_attach = on_attach,
          capabilities = vim.tbl_deep_extend("force", get_capabilities(), {
            offsetEncoding = { "utf-16" },
          }),
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
        },
        extensions = {
          autoSetHints = true,
          inlay_hints = {
            inline = vim.fn.has("nvim-0.10") == 1,
            only_current_line = false,
            only_current_line_autocmd = "CursorHold",
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
      })
    end,
  },
  {
    "tiny-inline-diagnostic.nvim",
    lazy = false,
    priority = 1001,
    after = function()
      vim.diagnostic.config({ virtual_text = false })
      require("tiny-inline-diagnostic").setup({
        preset = "powerline",
        transparent_bg = false,
        options = {
          show_source = true,
          use_icons_from_diagnostic = true,
          multilines = {
            enabled = true,
            always_show = false,
          },
          overflow = {
            mode = "wrap",
          },
        },
      })
    end,
  },
  {
    "lspkind.nvim",
    lazy = false,
  },
}
