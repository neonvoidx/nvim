local project_root = require("util").project_root

local map = vim.keymap.set

local function get_visual()
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")
  local ls, cs = start_pos[2], start_pos[3]
  local le, ce = end_pos[2], end_pos[3]
  if ls > le or (ls == le and cs > ce) then
    ls, le = le, ls
    cs, ce = ce, cs
  end
  return vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
end

local function compare_to_clip()
  local ftype = vim.api.nvim_get_option_value("filetype", { buf = 0 })
  vim.cmd("vsplit")
  vim.cmd("enew")
  vim.cmd("normal! P")
  vim.opt_local.buftype = "nowrite"
  vim.opt_local.filetype = ftype
  vim.cmd("diffthis")
  vim.cmd([[execute "normal! \<C-w>h"]])
  vim.cmd("diffthis")
end

local function delete_installed_plugin()
  local plugins = vim.pack.get()
  if not plugins or vim.tbl_isempty(plugins) then
    vim.notify("No installed plugins found", vim.log.levels.INFO)
    return
  end

  table.sort(plugins, function(a, b)
    return a.spec.name < b.spec.name
  end)

  vim.ui.select(plugins, {
    prompt = "Delete plugin",
    format_item = function(plugin)
      return string.format("%s (%s)", plugin.spec.name, plugin.spec.src)
    end,
  }, function(plugin)
    if not plugin then
      return
    end

    vim.ui.input({
      prompt = string.format("Delete %s? Type yes: ", plugin.spec.name),
    }, function(input)
      if input ~= "yes" then
        return
      end

      vim.pack.del({ plugin.spec.name })
      vim.notify(string.format("Deleted plugin %s", plugin.spec.name), vim.log.levels.INFO)
    end)
  end)
end

-- Core editing and movement
map("i", "jj", "<Esc>")
map("i", "kk", "<Esc>")
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map("n", "<leader>wd", "<cmd>q<cr>", { desc = "Delete window", remap = true })
map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split right", remap = true })
map("n", "<leader>w-", "<cmd>split<cr>", { desc = "Split below", remap = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<C-q>", "<cmd>silent! xa<cr>", { desc = "Save all and quit" })
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Safety and clipboard
local esc_modes = { "i", "n", "v", "x", "o", "t", "s", "c", "l" }
map(esc_modes, "<Insert>", "<Esc>")
map(esc_modes, "<F1>", "<Nop>")
map(esc_modes, "<C-LeftMouse>", "<Nop>")
map("n", "<C-t>", "<Nop>")
map({ "n", "v" }, "D", '"_d')
map({ "n", "v" }, "C", '"_c')
map("v", "<C-r>", function()
  local pattern = table.concat(get_visual(), "\n")
  pattern = vim.fn.substitute(vim.fn.escape(pattern, "^$.*\\/~[]"), "\n", "\\n", "g")
  vim.cmd.normal({ bang = true, args = { "<Esc>" } })
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(":%s/" .. pattern .. "//g<Left><Left>", true, false, true), "n")
end, { desc = "Search and replace selection" })
map("n", "<leader>D", compare_to_clip, { desc = "Diff vs clipboard" })

-- Buffers and tabs
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bd<CR>>", { desc = "Delete buffer" })
map("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle pin" })
map("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
map("n", "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", { desc = "Delete other buffers" })
map("n", "<leader>br", "<Cmd>BufferLineCloseRight<CR>", { desc = "Delete buffers to the right" })
map("n", "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", { desc = "Delete buffers to the left" })
map("n", "<S-Right>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
map("n", "<S-Left>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })

-- UI and editor helpers
map("n", "==", "gg<S-v>G")
map("n", "<A-a>", "ggVG", { noremap = true, silent = true, desc = "Select all" })
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)
map("n", "<leader>uR", "<cmd>restart<cr>", { desc = "Restart UI" })
map("n", "<leader>uu", function()
  vim.pack.update()
end, { desc = "Update plugins" })
map("n", "<leader>um", "<cmd>messages<cr>", { desc = "Messages", silent = true })
map("n", "<leader>ud", delete_installed_plugin, { desc = "Delete plugin" })
map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Line wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle line wrap" })
map("n", "<C-c>", ":%y+<CR>", { noremap = true, silent = true })
map("n", "zv", "zMzvzz", { desc = "Close all folds except the current one" })
map("n", "zj", "zcjzOzz", { desc = "Close current fold when open. Always open next fold." })
map("n", "gl", "$", { desc = "Go to end of line" })
map("n", "gh", "^", { desc = "Go to start of line" })
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })
map("n", "<leader>nm", "<cmd>:message<cr>", { desc = "Message history" })

-- Insert-mode completion
map("i", "<C-j>", function()
  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, false, true), "n", true)
    return ""
  end
  return vim.api.nvim_replace_termcodes("<C-j>", true, false, true)
end, { expr = true, silent = true, desc = "Next completion item" })
map("i", "<C-k>", function()
  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, false, true), "n", true)
    return ""
  end
  return vim.api.nvim_replace_termcodes("<C-k>", true, false, true)
end, { expr = true, silent = true, desc = "Prev completion item" })
map(
  "i",
  "<CR>",
  'pumvisible() ? (complete_info(["selected"]).selected != -1 ? "\\<C-y>" : "\\<CR>") : "\\<CR>"',
  { expr = true, silent = true, desc = "Confirm completion" }
)

-- Plugin integrations
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open Lazygit" })
map("n", "<leader><leader>", function()
  require("fff").find_files()
end, { desc = "Find files" })
map("n", "<leader>f", function()
  require("fff").find_files()
end, { desc = "Find files" })
map("n", "<leader>/", function()
  require("fff").live_grep()
end, { desc = "Grep" })
map("v", "<leader>/", function()
  local query = table.concat(get_visual(), "\n")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  require("fff").live_grep({ query = query })
end, { desc = "Grep (visual)" })
map({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
  require("flash").remote()
end, { desc = "Remote Flash" })
map({ "x", "o" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
map("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })
map("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { desc = "Go to Treesitter context" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics_buffer toggle<cr>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
map("n", "<leader>e", function()
  local buf_path = vim.api.nvim_buf_get_name(0)
  local path = buf_path ~= "" and vim.fn.fnamemodify(buf_path, ":p:h") or vim.fn.getcwd()
  require("yazi").yazi(nil, path)
end, { desc = "Yazi (here)" })
map("n", "<leader>E", function()
  require("yazi").yazi(nil, project_root())
end, { desc = "Yazi (root)" })

-- Formatting
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
