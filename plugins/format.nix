{ pkgs, ... }:
{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          javascript = [
            "eslint_d"
            "prettierd"
          ];
          typescript = [
            "eslint_d"
            "prettierd"
          ];
          javascriptreact = [
            "eslint_d"
            "prettierd"
          ];
          typescriptreact = [
            "eslint_d"
            "prettierd"
          ];
          "javascript.jsx" = [
            "eslint_d"
            "prettierd"
          ];
          "typescript.tsx" = [
            "eslint_d"
            "prettierd"
          ];
          css = [ "prettierd" ];
          html = [ "prettierd" ];
          json = [ "prettierd" ];
          yaml = [ "prettierd" ];
          lua = [ "stylua" ];
          kdl = [ "kdlfmt" ];
          python = [
            "isort"
            "black"
          ];
          markdown = [
            "prettierd"
            "markdownlint-cli2"
            "markdown-toc"
          ];
          "markdown.mdx" = [
            "prettierd"
            "markdownlint-cli2"
            "markdown-toc"
          ];
          nix = [ "nixfmt" ];
        };
        notify_on_error = false;
        formatters.prettierd.require_cwd = true;
        format_on_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
      };
    };

    lint = {
      enable = true;
      lintersByFt = {
        typescript = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        javascript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        "javascript.jsx" = [ "eslint_d" ];
        cmake = [ "cmakelint" ];
      };
    };
  };

  extraConfigLua = ''
    vim.g.disable_autoformat = false

    -- Trigger linting on buffer events
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })
    vim.env.ESLINT_D_PPID = vim.fn.getpid()
  '';

  extraPackages = with pkgs; [
    stylua
    isort
    black
    prettierd
    markdownlint-cli2
    kdlfmt
    pylint
    nodePackages.eslint
    cmake-format
    nixfmt-rfc-style
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>cf";
      action.__raw = ''
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          local state = vim.g.disable_autoformat and "disabled" or "enabled"
          vim.notify("Autoformat " .. state, vim.log.levels.INFO, { title = "Conform" })
        end
      '';
      options.desc = "Toggle format";
    }
    {
      mode = "n";
      key = "<leader>cF";
      action.__raw = ''
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat
          local state = vim.b[bufnr].disable_autoformat and "disabled" or "enabled"
          vim.notify("Autoformat " .. state .. " (buffer)", vim.log.levels.INFO, { title = "Conform" })
        end
      '';
      options.desc = "Toggle format (buffer)";
    }
  ];
}
