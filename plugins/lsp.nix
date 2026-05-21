{ pkgs, lib, ... }:
{
  config.vim = {
    lsp = {
      enable = true;
      formatOnSave = false; # handled by conform.nvim
      inlayHints.enable = false;

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
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = false; # null-ls not used

      typescript = {
        enable = true;
        lsp.enable = true;
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
        lsp.enable = true;
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
      -- Add Hyprland Lua stubs to LuaLS when running in a Nix environment.
      do
        if vim.fn.executable("nix") == 1 then
          local handle = io.popen("nix eval nixpkgs#hyprland.outPath --raw 2>/dev/null")
          if handle then
            local out = handle:read("*a")
            handle:close()

            local hyprland_out = vim.trim(out)
            if hyprland_out ~= "" then
              local stub_dir = hyprland_out .. "/share/hypr/stubs"
              local stub_file = stub_dir .. "/hl.meta.lua"

              if vim.uv.fs_stat(stub_file) then
                vim.lsp.config("lua_ls", {
                  settings = {
                    Lua = {
                      workspace = {
                        library = {
                          [stub_dir] = true,
                        },
                      },
                    },
                  },
                })
              end
            end
          end
        end
      end

      -- ── Zig ────────────────────────────────────────────────────────
      -- Disable zig.vim's built-in fmt-on-save; conform's lsp_format="fallback"
      -- already delegates to ZLS (which runs zig fmt) on BufWritePre.
      vim.g.zig_fmt_autosave = 0
      vim.g.zig_fmt_parse_errors = 0

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

          map("n", "<leader>ca", vim.lsp.buf.code_action, e("Code action (line)"))
          map("n", "<leader>cA", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source" }, diagnostics = {} },
            })
          end, e("Code action (buffer)"))
          map("n", "<leader>li", "<cmd>checkhealth lsp<cr>",              e("LSP Info"))
          map("n", "<leader>ll", "<cmd>lua vim.cmd('e '..vim.lsp.get_log_path())<cr>", e("LSP Logs"))
          map("n", "<leader>r",  "<cmd>LspRestart<cr>",                 e("LSP Restart"))
        end,
      })
    '';
  };
}
