local project_root = require("util").project_root()

require("persistence").setup({
  main = project_root,
})

vim.schedule(function()
  require("persistence").load()
end)
-- load the session for the current directory
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Load session" })

-- select a session to load
vim.keymap.set("n", "<leader>qS", function()
  require("persistence").select()
end, { desc = "Select session" })

-- load the last session
vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Load last session" })
