local notify = require("notify")

notify.setup({
  stages = "fade_in_slide_out",
  timeout = 3000,
  render = "wrapped-compact",
})

vim.notify = notify

local lsp_progress_notifications = {}

vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("NotifyLspProgress", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value
    if not value or type(value) ~= "table" then
      return
    end

    local token = string.format("%s:%s", ev.data.client_id, ev.data.params.token)
    local state = lsp_progress_notifications[token] or {}
    state.client_name = client and client.name
    state.value = vim.deepcopy(value)
    lsp_progress_notifications[token] = state

    if state.scheduled then
      return
    end
    state.scheduled = true

    vim.schedule(function()
      state.scheduled = false
      local latest = state.value
      if not latest then
        return
      end

      local percentage = latest.percentage and string.format(" (%d%%)", latest.percentage) or ""
      local message = latest.message or latest.title or "Working"
      if percentage ~= "" then
        message = message .. percentage
      end

      local record = notify.notify(message, vim.log.levels.INFO, {
        title = state.client_name and ("LSP: " .. state.client_name) or "LSP",
        replace = state.record,
        timeout = latest.kind == "end" and 1000 or false,
        hide_from_history = true,
      })

      if latest.kind == "end" then
        lsp_progress_notifications[token] = nil
      else
        state.record = record
      end
    end)
  end,
})
