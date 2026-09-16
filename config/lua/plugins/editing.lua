-- Editing: mini, flash, yanky, numb, illuminate, todo-comments, guess-indent
local map = vim.keymap.set

-- ── mini.pairs ────────────────────────────────────────────────────────
require("mini.pairs").setup({
  modes = { insert = true, command = false, terminal = false },
})

-- ── mini.surround ─────────────────────────────────────────────────────
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
    update_n_lines = "gsn",
  },
})

-- ── flash ─────────────────────────────────────────────────────────────
require("flash").setup({ auto_jump = true, multi_window = false })
map("n", "s", function() require("flash").jump() end, { desc = "Flash jump" })
map("n", "S", function() require("flash").treesitter_search() end, { desc = "Flash treesitter search" })

-- ── yanky ─────────────────────────────────────────────────────────────
require("yanky").setup({
  highlight = { timer = 200 },
  ring = { storage = "shada" },
})
map({ "n", "x" }, "y", "<Plug>(YankyYank)")
map("n", "p", "<Plug>(YankyPutAfterLinewise)")
map("n", "P", "<Plug>(YankyPutBeforeLinewise)")
map("x", "p", "<Plug>(YankyPutAfter)")
map("x", "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyCycleForward)")
map("n", "<c-n>", "<Plug>(YankyCycleBackward)")
map("n", "<leader>pp", "<cmd>YankyRingHistory<cr>", { desc = "Yank history" })

-- ── numb ──────────────────────────────────────────────────────────────
require("numb").setup()

-- ── illuminate ────────────────────────────────────────────────────────
require("illuminate").configure({ providers = { "lsp", "treesitter", "regex" } })

-- ── todo-comments ─────────────────────────────────────────────────────
require("todo-comments").setup({
  signs = true,
  merge_keywords = false,
  keywords = {
    BUG = { icon = "", color = "error" },
    FIXME = { icon = "", color = "error" },
    HACK = { icon = "", color = "info" },
    NOTE = { icon = "❦", color = "info" },
    TODO = { icon = "★", color = "actionItem" },
    WARN = { icon = "󰀦", color = "warning" },
  },
  colors = {
    actionItem = { "ActionItem", "#f1fc79" },
    default = { "Identifier", "#37f499" },
    error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
    info = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
    warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
  },
  highlight = { keyword = "bg", pattern = [[.*<(KEYWORDS)\s*]] },
  search = {
    command = "rg",
    args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
    pattern = [[\b(KEYWORDS)\b]],
  },
})

-- ── guess-indent ──────────────────────────────────────────────────────
require("guess-indent").setup()