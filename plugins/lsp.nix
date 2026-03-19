{ pkgs, lib, ... }:
{
  config.vim = {
    lsp = {
      enable = true;
      formatOnSave = false; # handled by conform.nvim
      inlayHints.enable = true;

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

      ts = {
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
        format.enable = true;
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
    };

    extraPackages = with pkgs; [
      ripgrep
      fd
    ];

    startPlugins = with pkgs.vimPlugins; [
      tiny-inline-diagnostic-nvim
      inc-rename-nvim
      vim-illuminate # also enabled via vim.ui.illuminate but kept here for awareness
    ];

    luaConfigRC."lsp-extra" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── Tiny Inline Diagnostic ─────────────────────────────────────
      require("tiny-inline-diagnostic").setup({
        options = {
          show_source = { enabled = true },
          multilines  = { enabled = true },
        },
      })
      -- Disable built-in virtual_text since tiny-inline-diagnostic replaces it
      vim.diagnostic.config({ virtual_text = false })

      -- ── Inc-Rename ─────────────────────────────────────────────────
      require("inc_rename").setup({})
      vim.keymap.set("n", "<leader>cr", ":IncRename ", { desc = "Rename symbol" })

      -- ── Extra LSP keymaps (LspAttach) ──────────────────────────────
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map  = vim.keymap.set
          local opts = { buffer = ev.buf }
          local e    = function(desc) return vim.tbl_extend("force", opts, { desc = desc }) end

          map("n", "<space>cA", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source" }, diagnostics = {} },
            })
          end, e("Code action (buffer)"))
          map("n", "<leader>Li", "<cmd>LspInfo<cr>",    e("LSP Info"))
          map("n", "<leader>Ll", "<cmd>LspLog<cr>",     e("LSP Logs"))
          map("n", "<leader>r",  "<cmd>LspRestart<cr>", e("LSP Restart"))
        end,
      })
    '';
  };
}
