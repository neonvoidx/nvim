{ pkgs, lib, ... }:
{
  config.vim = {
    lsp = {
      enable = true;
      formatOnSave = false; # handled by conform.nvim
      inlayHints.enable = true;

      presets.vtsls.enable = true;

      servers."lua-language-server" = {
        root_markers = [
          ".luarc.json"
          ".luarc.jsonc"
          ".luacheckrc"
          ".stylua.toml"
          "stylua.toml"
          "selene.toml"
          "selene.yml"
          ".git"
        ];
        settings.Lua = {
          hint = {
            enable = true;
            setType = true;
            paramType = true;
            paramName = "all";
            arrayIndex = "auto";
          };
          runtime.version = "LuaJIT";
          diagnostics.globals = [
            "vim"
            "require"
          ];
          workspace = {
            checkThirdParty = false;
            library = lib.generators.mkLuaInline "{ vim.env.VIMRUNTIME }";
          };
          telemetry.enable = false;
        };
      };

      servers.vtsls = {
        filetypes = [
          "typescript"
          "typescriptreact"
          "javascript"
          "javascriptreact"
        ];
        settings = {
          complete_function_calls = true;
          vtsls = {
            enableMoveToFileCodeAction = true;
            autoUseWorkspaceTsdk = true;
            experimental = {
              maxInlayHintLength = 30;
              completion.enableServerSideFuzzyMatch = true;
            };
          };
          typescript = {
            updateImportsOnFileMove.enabled = "always";
            suggest.completeFunctionCalls = true;
            inlayHints = {
              enumMemberValues.enabled = true;
              functionLikeReturnTypes.enabled = true;
              parameterNames.enabled = "literals";
              parameterTypes.enabled = true;
              propertyDeclarationTypes.enabled = true;
              variableTypes.enabled = false;
            };
            preferences.importModuleSpecifier = "relative";
          };
        };
      };

      lspkind = {
        enable = true;
        setupOpts.mode = "symbol_text";
      };

      trouble = {
        enable = true;
        setupOpts = {
          modes = {
            diagnostics_buffer = {
              mode = "diagnostics";
              filter.buf = 0;
            };
          };
        };
      };

      # nixd settings for nixpkgs + home-manager completions
      servers.nixd.settings = {
        nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> { }";
          };
          options = {
            home-manager = {
              expr = "(import <home-manager/modules> { configuration = { home.username = \"_\"; home.homeDirectory = \"/tmp\"; home.stateVersion = \"26.05\"; }; pkgs = import <nixpkgs> {}; }).options";
            };
          };
        };
      };
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = false; # null-ls not used

      typescript = {
        enable = true;
        lsp.enable = true;
        lsp.servers = [ ];
        treesitter.enable = true;
        format.enable = true;
      };

      lua = {
        enable = true;
        lsp = {
          enable = true;
          lazydev.enable = true; # lazydev.nvim for neovim API completions
        };
        treesitter.enable = true;
        format.enable = true;
      };

      nix = {
        enable = true;
        lsp = {
          enable = true;
          servers = [ "nixd" ];
        };
        treesitter.enable = true;
        format = {
          enable = true;
          type = [ "nixfmt" ];
        };
      };

      rust = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
      };

      python = {
        enable = true;
        lsp = {
          enable = true;
          servers = [ "basedpyright" ];
        };
        treesitter.enable = true;
        format.enable = true;
      };

      clang = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      go = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        format.enable = true;
      };

      yaml = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };

      markdown = {
        enable = true;
        lsp.enable = false; # markdown LSP is heavy; rely on lint
        treesitter.enable = true;
        format.enable = true;
      };

      odin = {
        enable = true;
        # TODO: Re-enable once OLS/odin-dev no longer pulls a broken
        # compiler-rt build on Darwin in this lockfile. Keep Odin editing
        # support without making Neovim depend on that toolchain.
        lsp.enable = false;
        treesitter.enable = true;
      };

      zig = {
        enable = true;
        lsp.enable = true;
        treesitter.enable = true;
      };
    };

    extraPackages = with pkgs; [
      ripgrep
      fd
      arduino-language-server
      arduino-cli
      clang-tools # provides clangd for arduino-language-server
    ];

    startPlugins = with pkgs.vimPlugins; [
      tiny-inline-diagnostic-nvim
      inc-rename-nvim
      vim-illuminate # also enabled via vim.ui.illuminate but kept here for awareness
    ];

    luaConfigRC."lsp-extra" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── Zig ────────────────────────────────────────────────────────
      -- Disable zig.vim's built-in fmt-on-save; conform's lsp_format="fallback"
      -- already delegates to ZLS (which runs zig fmt) on BufWritePre.
      vim.g.zig_fmt_autosave = 0
      vim.g.zig_fmt_parse_errors = 0
      vim.g.inlay_hints_manually_disabled = false

      vim.lsp.inlay_hint.enable(true)

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

      -- ── Tiny Inline Diagnostic ─────────────────────────────────────
      require("tiny-inline-diagnostic").setup({
        options = {
          show_source = { enabled = true },
          multilines  = { enabled = true },
        },
      })
      -- Disable built-in virtual_text since tiny-inline-diagnostic replaces it
      vim.diagnostic.config({ virtual_text = false })

      -- ── Trouble ────────────────────────────────────────────────────
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics_buffer toggle<cr>",
        { desc = "Buffer diagnostics (Trouble)" })

      -- ── Inc-Rename ─────────────────────────────────────────────────
      require("inc_rename").setup({})
      vim.keymap.set("n", "<leader>cr", ":IncRename ", { desc = "Rename symbol" })

      -- ── Arduino Language Server ─────────────────────────────────────
      -- Requires one-time setup: arduino-cli config init && arduino-cli core install arduino:avr
      -- Per-project FQBN: set in .vscode/arduino.json → { "board": "arduino:avr:uno" }
      vim.filetype.add({ extension = { ino = "arduino" } })

      vim.lsp.config["arduino_language_server"] = {
        cmd = { "arduino-language-server", "-clangd", "clangd", "-cli", "arduino-cli" },
        filetypes = { "arduino" },
        root_dir = function(bufnr)
          -- vim.fs.root does not support globs; fall back to buffer directory
          return vim.fs.root(bufnr, { "sketch.yaml", ".git" })
            or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:h")
        end,
      }
      vim.lsp.enable("arduino_language_server")

      -- ── Extra LSP keymaps (LspAttach) ──────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map  = vim.keymap.set
          local opts = { buffer = ev.buf }
          local e    = function(desc) return vim.tbl_extend("force", opts, { desc = desc }) end

          map("n", "K", vim.lsp.buf.hover, e("Hover documentation"))
          map("n", "gK", vim.lsp.buf.signature_help, e("Signature help"))
          map("n", "gi", vim.lsp.buf.implementation, e("Go to implementation"))
          map("n", "<leader>ca", vim.lsp.buf.code_action, e("Code action (line)"))
          map("n", "<leader>cA", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source" }, diagnostics = {} },
            })
          end, e("Code action (buffer)"))
          map("n", "<leader>cs", vim.lsp.buf.document_symbol, e("Document symbols"))
          map("n", "<leader>cS", vim.lsp.buf.workspace_symbol, e("Workspace symbols"))
          map("n", "<leader>li", "<cmd>checkhealth lsp<cr>",              e("LSP Info"))
          map("n", "<leader>ll", "<cmd>lua vim.cmd('e '..vim.lsp.get_log_path())<cr>", e("LSP Logs"))
          map("n", "<leader>lr", "<cmd>LspRestart<cr>",                 e("LSP Restart"))
          map("n", "<leader>lI", function()
            local enabled = not vim.lsp.inlay_hint.is_enabled({})
            vim.lsp.inlay_hint.enable(enabled)
            vim.g.inlay_hints_manually_disabled = not enabled
            vim.notify("Inlay hints: " .. (enabled and "on" or "off"))
          end, e("Toggle inlay hints"))
        end,
      })
    '';
  };
}
