{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      conform-nvim
      nvim-lint
    ];

    luaConfigRC."format" = lib.nvim.dag.entryAnywhere ''
      -- ── Conform (formatting) ─────────────────────────────────────────
      vim.g.disable_autoformat = false

      require("conform").setup({
        formatters_by_ft = {
          javascript      = { "eslint_d", "prettierd" },
          typescript      = { "eslint_d", "prettierd" },
          javascriptreact = { "eslint_d", "prettierd" },
          typescriptreact = { "eslint_d", "prettierd" },
          ["javascript.jsx"] = { "eslint_d", "prettierd" },
          ["typescript.tsx"] = { "eslint_d", "prettierd" },
          css      = { "prettierd" },
          html     = { "prettierd" },
          json     = { "prettierd" },
          yaml     = { "prettierd" },
          lua      = { "stylua" },
          python   = { "isort", "black" },
          markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
          ["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
          nix      = { "nixfmt" },
        },
        notify_on_error = false,
        formatters = {
          prettierd = { require_cwd = true },
        },
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
      })

      vim.keymap.set("n", "<leader>cf", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        local state = vim.g.disable_autoformat and "disabled" or "enabled"
        vim.notify("Autoformat " .. state, vim.log.levels.INFO, { title = "Conform" })
      end, { desc = "Toggle autoformat" })

      vim.keymap.set("n", "<leader>cF", function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat
        local state = vim.b[bufnr].disable_autoformat and "disabled" or "enabled"
        vim.notify("Autoformat " .. state .. " (buffer)", vim.log.levels.INFO, { title = "Conform" })
      end, { desc = "Toggle autoformat (buffer)" })

      -- ── nvim-lint (linting) ──────────────────────────────────────────
      vim.env.ESLINT_D_PPID = vim.fn.getpid()

      require("lint").linters_by_ft = {
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        javascript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        ["javascript.jsx"] = { "eslint_d" },
        ["typescript.tsx"]  = { "eslint_d" },
        cmake = { "cmakelint" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          require("lint").try_lint()
        end,
      })
    '';
  };
}
