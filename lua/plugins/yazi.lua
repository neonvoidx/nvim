local map = vim.keymap.set
local project_root = require("plugins.util").project_root

require("yazi").setup({
  open_for_directories = true,
})

map("n", "<leader>e", function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local path = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or vim.fn.getcwd()
  require("yazi").yazi(nil, path)
end, { desc = "Yazi (here)" })
map("n", "<leader>E", function()
  require("yazi").yazi(nil, project_root())
end, { desc = "Yazi (root)" })
