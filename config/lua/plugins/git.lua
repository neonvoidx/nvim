-- Git: gitsigns only (ports of the trimmed reference setup)
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 100 },
  signs = {
    add = { text = "+" },
    change = { text = "± " },
    delete = { text = "˗" },
    topdelete = { text = "󰕮" },
    changedelete = { text = "±" },
  },
  on_attach = function(bufnr)
    local map = vim.keymap.set
    local opts = function(desc) return { buffer = bufnr, desc = desc } end
    map("n", "]h", function() require("gitsigns").next_hunk() end, opts("Next hunk"))
    map("n", "[h", function() require("gitsigns").prev_hunk() end, opts("Prev hunk"))
  end,
})