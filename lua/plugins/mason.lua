-- Mason is only set up on non-nix systems.
-- On NixOS, LSP servers and tools come from nixpkgs extraPackages.
if vim.g.mason_disabled then
  return {}
end

return {
  {
    "mason.nvim",
    lazy = false,
    after = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP
          "bashls", "jsonls", "gopls", "lua_ls", "basedpyright",
          "yamlls", "docker_compose_language_service", "dockerls",
          "neocmake", "vtsls", "terraformls", "clangd", "zls",
          "emmet_language_server", "fish_lsp", "typos_lsp",
          -- Linters
          "mmdc", "pylint", "eslint_d", "checkmake", "terraform",
          "yamllint", "cmakelint", "cmakelang",
          -- DAP
          "codelldb",
          -- Formatters
          "stylua", "isort", "black", "prettierd",
          "markdownlint-cli2", "markdown-toc", "kdlfmt",
        },
      })
    end,
    keys = {
      { "<leader>Lm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
  {
    "mason-lspconfig.nvim",
    lazy = false,
    after = function()
      require("mason-lspconfig").setup({ automatic_enable = true })
    end,
  },
}
