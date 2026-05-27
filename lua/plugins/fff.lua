vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "fff.nvim" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("fff.nvim")
      end
      require("fff.download").download_or_build_binary()
    end
  end,
})
local fff_download = require("fff.download")
local fff_binary = fff_download.get_binary_path()
if not vim.uv.fs_stat(fff_binary) then
  local ok, err = pcall(fff_download.download_or_build_binary)
  if not ok then
    vim.notify("fff.nvim binary build failed: " .. tostring(err), vim.log.levels.WARN)
  end
end
require("fff").setup({
  base_path = vim.fn.getcwd(),
  lazy_sync = true,
  debug = {
    enabled = true,
    show_scores = true,
    show_file_info = { file_info = true, score_breakdown = false, timings = false, full_path = false },
  },
  title = "🗲 fff",
  prompt = "> ",
  layout = { prompt_position = "top", height = 0.9, width = 0.9 },
  keymaps = { move_up = { "<Up>", "<C-k>" }, move_down = { "<Down>", "<C-j>" } },
})
