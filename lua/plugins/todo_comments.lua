require("todo-comments").setup({
  signs = true,
  merge_keywords = false,
  keywords = {
    BUG = { icon = "", color = "error" },
    FIXME = { icon = "", color = "error", alt = { "fixme" } },
    HACK = { icon = "", color = "info" },
    NOTE = { icon = "❦", color = "info", alt = { "note" } },
    TODO = { icon = "★", color = "actionItem", alt = { "todo" } },
    WARN = { icon = "󰀦", color = "warning", alt = { "warning", "warn" } },
  },
  colors = {
    actionItem = { "ActionItem", "#f1fc79" },
    default = { "Identifier", "#37f499" },
    error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
    info = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
    warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
  },
  highlight = {
    keyword = "bg",
    pattern = [[.*<(KEYWORDS)\s*]],
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS)\b]],
  },
})

vim.keymap.set("n", "<leader>st", function()
  require("todo-comments.fzf").todo({ keywords = { "TODO", "todo" } })
end, { desc = "TODOs" })
vim.keymap.set("n", "<leader>sT", ":TodoFzfLua<cr>", { desc = "TODO/BUG/FIXME/HACK/NOTE/WARN" })
