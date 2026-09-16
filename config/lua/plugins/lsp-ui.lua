-- LSP tooling: inc-rename, trouble
local map = vim.keymap.set

require("inc_rename").setup({})
map("n", "<leader>cr", ":IncRename ", { desc = "Rename symbol" })

require("trouble").setup({
  modes = {
    diagnostics_buffer = {
      mode = "diagnostics",
      filter = { buf = 0 },
    },
  },
})
map("n", "<leader>xx", "<cmd>Trouble diagnostics_buffer toggle<cr>", { desc = "Buffer diagnostics (Trouble)" })