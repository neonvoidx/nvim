{ pkgs, ... }:
{
  plugins = {
    # ── Core LSP ─────────────────────────────────────────────────────────
    lsp = {
      enable = true;
      inlayHints = true;

      # Keymaps added on every LSP attach
      keymaps = {
        silent = true;
        lspBuf = {
          K = "hover";
        };
        extra = [
          {
            key = "<leader>cr";
            action.__raw = "vim.lsp.buf.rename";
            options.desc = "Rename";
          }
          {
            mode = [
              "n"
              "v"
            ];
            key = "<leader>ca";
            action.__raw = "vim.lsp.buf.code_action";
            options.desc = "Code Action";
          }
          {
            key = "<leader>li";
            action = "<cmd>LspInfo<cr>";
            options.desc = "LSP Info";
          }
          {
            key = "<leader>ll";
            action = "<cmd>LspLog<cr>";
            options.desc = "LSP Log";
          }
          {
            key = "<leader>lr";
            action = "<cmd>LspRestart<cr>";
            options.desc = "LSP Restart";
          }
        ];
      };

      # ── Language servers ───────────────────────────────────────────────
      servers = {
        bashls.enable = true;

        jsonls = {
          enable = true;
          # settings are wrapped as { json = settings } by nixvim
          settings = {
            schemas.__raw = "require('schemastore').json.schemas()";
            validate.enable = true;
          };
        };

        gopls = {
          enable = true;
          settings.gopls = {
            analyses.unusedparams = true;
            staticcheck = true;
          };
        };

        lua_ls = {
          enable = true;
          # settings are wrapped as { Lua = settings } by nixvim
          settings = {
            workspace.checkThirdParty = false;
            completion.callSnippet = "Replace";
            doc.privateName = [ "^_" ];
            type.castNumberToInteger = true;
            diagnostics.disable = [
              "incomplete-signature-doc"
              "trailing-space"
            ];
            hint = {
              enable = true;
              setType = false;
              paramType = true;
              paramName = "Disable";
              semicolon = "Disable";
              arrayIndex = "Disable";
            };
          };
        };

        basedpyright = {
          enable = true;
          settings.basedpyright.analysis = {
            autoSearchPaths = true;
            autoImportCompletions = true;
          };
        };

        yamlls = {
          enable = true;
          # settings are wrapped as { yaml = settings } by nixvim
          settings.schemaStore = {
            enable = false;
            url = "";
          };
        };

        docker_compose_language_service.enable = true;
        dockerls.enable = true;

        neocmake.enable = true;

        vtsls = {
          enable = true;
          filetypes = [
            "javascript"
            "javascriptreact"
            "javascript.jsx"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
          ];
          settings = {
            complete_function_calls = true;
            vtsls = {
              enableMoveToFileCodeAction = true;
              autoUseWorkspaceTsdk = true;
              experimental.completion.enableServerSideFuzzyMatch = true;
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
            };
          };
        };

        terraformls.enable = true;

        emmet_language_server.enable = true;

        nil_ls.enable = true;
      };
    };

    # ── Schemastore (JSON/YAML schemas) ──────────────────────────────────
    schemastore.enable = true;

    # ── Lazydev (Lua LSP enhancement) ─────────────────────────────────────
    lazydev = {
      enable = true;
      settings.library = [
        {
          path = "\${3rd}/luv/library";
          words = [ "vim%.uv" ];
        }
      ];
    };

    # ── Vim-illuminate ───────────────────────────────────────────────────
    illuminate = {
      enable = true;
      settings = {
        providers = [
          "lsp"
          "treesitter"
          "regex"
        ];
        delay = 200;
        filetypes_denylist = [
          "dirbuf"
          "dirvish"
          "fugitive"
        ];
      };
    };

    # ── Trouble ──────────────────────────────────────────────────────────
    trouble = {
      enable = true;
      settings.modes.lsp_references.params.include_declaration = true;
    };

    # ── Inc-rename ────────────────────────────────────────────────────────
    inc-rename = {
      enable = true;
      settings = { };
    };

    # ── Rustaceanvim ─────────────────────────────────────────────────────
    rustaceanvim = {
      enable = true;
      settings.server = {
        default_settings."rust-analyzer" = {
          cargo = {
            allFeatures = true;
            loadOutDirsFromCheck = true;
            buildScripts.enable = true;
          };
          checkOnSave = true;
          check = {
            command = "clippy";
            extraArgs = [
              "--all"
              "--"
              "-W"
              "clippy::pedantic"
            ];
          };
          procMacro = {
            enable = true;
            ignored = {
              async-trait = [ "async_trait" ];
              napi-derive = [ "napi" ];
              async-recursion = [ "async_recursion" ];
            };
          };
        };
      };
    };

    # ── Clangd extensions ─────────────────────────────────────────────────
    clangd-extensions = {
      enable = true;
      enableOffsetEncodingWorkaround = true;
    };

    # ── Tiny inline diagnostic ────────────────────────────────────────────
    tiny-inline-diagnostic = {
      enable = true;
      settings = {
        preset = "powerline";
        transparent_bg = false;
        options = {
          show_source = true;
          use_icons_from_diagnostic = true;
          multilines = {
            enabled = true;
            always_show = false;
          };
          overflow.mode = "wrap";
        };
      };
    };
  };

  # fish_lsp and typos_lsp – configure via extraConfigLua since they may not
  # be available on all systems (pcall fallback mirrors the original Lua config)
  extraConfigLua = ''
    -- Optional LSP servers (system-installed, not managed by Nix)
    pcall(function()
      vim.lsp.enable("fish_lsp")
    end)
    pcall(function()
      vim.lsp.enable("typos_lsp")
    end)
  '';

  extraPackages = with pkgs; [
    # LSP servers
    lua-language-server
    gopls
    basedpyright
    clang-tools
    bash-language-server
    vscode-langservers-extracted
    yaml-language-server
    docker-compose-language-service
    dockerfile-language-server-nodejs
    neocmakelsp
    terraform-ls
    emmet-language-server
    nil
    vtsls
    # Optional (may not exist on all platforms)
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options.desc = "Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
      options.desc = "Buffer Diagnostics (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options.desc = "Symbols (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options.desc = "LSP Definitions / references (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options.desc = "Location List (Trouble)";
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options.desc = "Quickfix List (Trouble)";
    }
    # Inc-rename overrides the LSP rename keymap
    {
      mode = "n";
      key = "<leader>cr";
      action = ":IncRename ";
      options.desc = "Rename symbol";
    }
  ];
}
