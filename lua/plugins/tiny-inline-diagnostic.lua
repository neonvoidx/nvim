require("tiny-inline-diagnostic").setup({
  preset = "modern",
  options = {
    show_source = { enabled = false },
    show_code = true,
    add_messages = { messages = true, display_count = false },
    multilines = { enabled = true, always_show = false },
    throttle = 20,
  },
})
