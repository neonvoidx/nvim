require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 100 },
  signs = {
    add = { text = "+" },
    change = { text = "± " },
    delete = { text = "˗" },
    topdelete = { text = "" },
    changedelete = { text = "±" },
  },
  on_attach = function(bufnr)
    local gitsigns = require("gitsigns.actions")
    -- Navigation
    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end, { desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end, { desc = "Prev hunk" })
    vim.keymap.set("n", "<leader>gb", function()
      gitsigns.blame()
    end, { buffer = bufnr, desc = "Toggle blame" })
    vim.keymap.set("n", "<leader>gd", function()
      gitsigns.diffthis()
    end, { buffer = bufnr, desc = "Diff this against upstream" })
    vim.keymap.set("n", "<leader>gc", function()
      gitsigns.show_commit()
    end, { buffer = bufnr, desc = "Show commit" })
    vim.keymap.set("n", "<leader>gh", function()
      gitsigns.setqflist()
    end, { buffer = bufnr, desc = "Send hunks to qf" })
    vim.keymap.set("n", "<leader>gr", function()
      local rev = vim.fn.input("Revision: ")
      gitsigns.show(rev)
    end, { buffer = bufnr, desc = "Show revision..." })
  end,
})
