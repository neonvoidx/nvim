-- UI: bufferline, which-key, nvim-highlight-colors
local map = vim.keymap.set

-- ── bufferline ────────────────────────────────────────────────────────
require("bufferline").setup({
  options = {
    mode = "buffers",
    numbers = "none",
    show_buffer_close_icons = false,
    themable = true,
    indicator = { style = "underline" },
    color_icons = true,
    separator_style = "thin",
    show_tab_indicators = false,
    show_buffer_icons = true,
    show_duplicate_prefix = false,
    max_name_length = 16,
    max_prefix_length = 10,
    tab_size = 25,
    truncate_names = true,
    hover = { enabled = false },
  },
})

map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
map("n", "<S-Right>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
map("n", "<S-Left>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
map("n", "<leader>bmn", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
map("n", "<leader>bmp", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle pin buffer" })
map("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Close non-pinned buffers" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })
map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })

-- ── which-key ─────────────────────────────────────────────────────────
local wk = require("which-key")
wk.setup({ preset = "helix", timeoutlen = 300 })
wk.add({
  { "<leader>E", desc = "Yazi cwd" },
  { "<leader>l", group = "+lsp" },
  { "<leader>b", group = "+buffers" },
  { "<leader>c", group = "+code" },
  { "<leader>e", desc = "Yazi" },
  { "<leader>f", group = "+find" },
  { "<leader>g", group = "+git" },
  { "<leader>p", group = "+yanky" },
  { "<leader>q", group = "+quickfix/session" },
  { "<leader>s", group = "+search" },
  { "<leader>u", group = "+ui" },
  { "<leader>w", group = "+window" },
  { "<leader>x", group = "+trouble" },
})

-- ── nvim-highlight-colors ─────────────────────────────────────────────
require("nvim-highlight-colors").setup({ render = "virtual" })