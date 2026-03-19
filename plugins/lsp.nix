{ pkgs, lib, ... }:
{
  config.vim = {
    # LSP servers and tools provided by Nix (replaces Mason)
    extraPackages = with pkgs; [
      lua-language-server
      gopls
      basedpyright
      zls
      clang-tools          # provides clangd
      yaml-language-server
      dockerfile-language-server-nodejs
      cmake-language-server
      nodePackages.typescript-language-server  # vtsls alternative available in nixpkgs
      nixd                 # nix LSP
      # Linters / formatters (also used by conform/lint)
      stylua
      nodePackages.prettier
      black
      isort
      nixfmt-rfc-style
      markdownlint-cli2
      ripgrep
      fd
    ];

    startPlugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      vim-illuminate
      trouble-nvim
      lazydev-nvim
      rustaceanvim
      clangd-extensions-nvim
      tiny-inline-diagnostic-nvim
      lspkind-nvim
      inc-rename-nvim
    ];

    luaConfigRC."lsp" = lib.nvim.dag.entryAnywhere ''
      -- ── LSP servers (Neovim 0.11 API: vim.lsp.config + vim.lsp.enable) ──

      vim.lsp.config("vtsls", {
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

      vim.lsp.config("clangd", {
        root_markers = {
          "compile_commands.json", "compile_flags.txt", "configure.ac",
          "Makefile", "config.h.in", "meson.build", "meson_options.txt",
          "build.ninja", ".git",
        },
        capabilities = { offsetEncoding = { "utf-16" } },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      })

      -- Enable configured servers
      vim.lsp.enable({
        "vtsls", "clangd", "lua_ls", "gopls", "basedpyright",
        "yamlls", "dockerls", "cmake", "nixd", "zls",
      })

      -- ── Illuminate (auto-highlight same word) ────────────────────────
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
      })

      -- ── LazyDev (Lua neovim API completions) ─────────────────────────
      require("lazydev").setup({
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      })

      -- ── Tiny Inline Diagnostic ───────────────────────────────────────
      require("tiny-inline-diagnostic").setup({
        options = {
          show_source = { enabled = true },
          multilines = { enabled = true },
          add_messages = { display_count = true },
        },
      })
      vim.diagnostic.config({ virtual_text = false })

      -- ── Inc-Rename ───────────────────────────────────────────────────
      require("inc_rename").setup({})
      vim.keymap.set("n", "<leader>cr", ":IncRename ", { desc = "Rename symbol" })

      -- ── Trouble ──────────────────────────────────────────────────────
      require("trouble").setup({
        modes = {
          diagnostics_buffer = {
            mode = "diagnostics",
            preview = {
              type = "float",
              relative = "editor",
              border = "rounded",
              title = "Preview",
              title_pos = "center",
              position = { 0, -2 },
              size = { width = 0.4, height = 0.4 },
              zindex = 200,
            },
            filter = { buf = 0 },
          },
        },
      })

      -- ── LSP keymaps (set on LspAttach) ───────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local map = vim.keymap.set
          map("n", "gD", vim.lsp.buf.declaration,    vim.tbl_extend("force", opts, { desc = "Goto declaration" }))
          map("n", "gd", vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "Goto definition" }))
          map("n", "K",  vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "Hover" }))
          map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
          map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action,
            vim.tbl_extend("force", opts, { desc = "Code action" }))
          map({ "n", "v" }, "<space>cA", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source" }, diagnostics = {} },
            })
          end, vim.tbl_extend("force", opts, { desc = "Code action (buffer)" }))
          map("n", "<space>cd", vim.diagnostic.open_float,
            vim.tbl_extend("force", opts, { desc = "Open diagnostic float" }))
          map("n", "<leader>Li", "<cmd>LspInfo<cr>",    vim.tbl_extend("force", opts, { desc = "LSP Info" }))
          map("n", "<leader>Ll", "<cmd>LspLog<cr>",     vim.tbl_extend("force", opts, { desc = "LSP Logs" }))
          map("n", "<leader>r",  "<cmd>LspRestart<cr>", vim.tbl_extend("force", opts, { desc = "LSP Restart" }))
          map("n", "[e", function()
            vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
          end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic error" }))
          map("n", "]e", function()
            vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
          end, vim.tbl_extend("force", opts, { desc = "Next diagnostic error" }))
        end,
      })

      -- ── Trouble keymaps ──────────────────────────────────────────────
      local map = vim.keymap.set
      map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>",           { desc = "Diagnostics (Trouble)" })
      map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics" })
      map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",   { desc = "Symbols (Trouble)" })
      map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP (Trouble)" })
      map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>",               { desc = "Location List (Trouble)" })
      map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>",               { desc = "Quickfix List (Trouble)" })

      -- ── Rustaceanvim ─────────────────────────────────────────────────
      vim.g.rustaceanvim = {}
    '';
  };
}
