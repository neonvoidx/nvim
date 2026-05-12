local map = vim.keymap.set

vim.g.disable_autoformat = false

require("conform").setup({
  notify_on_error = false,
  formatters = {
    prettierd = { require_cwd = true },
  },
  formatters_by_ft = {
    javascript = { "eslint_d", "prettierd" },
    typescript = { "eslint_d", "prettierd" },
    javascriptreact = { "eslint_d", "prettierd" },
    typescriptreact = { "eslint_d", "prettierd" },
    ["javascript.jsx"] = { "eslint_d", "prettierd" },
    ["typescript.tsx"] = { "eslint_d", "prettierd" },
    css = { "prettierd" },
    html = { "prettierd" },
    json = { "prettierd" },
    yaml = { "prettierd" },
    lua = { "stylua" },
    python = { "isort", "black" },
    markdown = { "prettierd", "markdownlint-cli2", "markdown-toc" },
    ["markdown.mdx"] = { "prettierd", "markdownlint-cli2", "markdown-toc" },
    nix = { "nixfmt" },
    rust = { "rustfmt" },
    go = { "gofmt" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,
})

map("n", "<leader>cf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify(
    "Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled"),
    vim.log.levels.INFO,
    { title = "Conform" }
  )
end, { desc = "Toggle autoformat" })

map("n", "<leader>cF", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat
  vim.notify(
    "Autoformat " .. (vim.b[bufnr].disable_autoformat and "disabled" or "enabled") .. " (buffer)",
    vim.log.levels.INFO,
    { title = "Conform" }
  )
end, { desc = "Toggle autoformat (buffer)" })
