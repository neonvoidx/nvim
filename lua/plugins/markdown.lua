return {
  {
    "render-markdown.nvim",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    after = function()
      require("render-markdown").setup({
        file_types = { "markdown", "norg", "rmd", "org", "codecompanion" },
        heading = { sign = false, icons = {} },
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
        dash = { width = 50 },
        checkbox = {
          unchecked = { icon = "✘ " },
          checked = { icon = "✔ " },
          custom = {
            in_progress = { raw = "[-]", rendered = "◐ ", highlight = "RenderMarkdownUnchecked" },
            important = { raw = "[!]", rendered = "◆ ", highlight = "DiagnosticError" },
          },
        },
      })
    end,
  },
  {
    "obsidian.nvim",
    ft = "markdown",
    cmd = {
      "ObsidianOpen", "ObsidianNew", "ObsidianQuickSwitch", "ObsidianFollowLink",
      "ObsidianBacklinks", "ObsidianToday", "ObsidianYesterday", "ObsidianTomorrow",
      "ObsidianTemplate", "ObsidianSearch", "ObsidianLink", "ObsidianLinkNew",
      "ObsidianWorkspace",
    },
    after = function()
      require("obsidian").setup({
        workspaces = {
          { name = "personal", path = "~/vaults/personal" },
        },
        ui = { enable = false }, -- render-markdown handles this
        picker = { name = "snacks.pick" },
        completion = { nvim_cmp = false, blink = true },
      })
    end,
    keys = {
      { "<leader>oo", "<cmd>ObsidianOpen<cr>",        desc = "Open Obsidian" },
      { "<leader>on", "<cmd>ObsidianNew<cr>",         desc = "New Note" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>",      desc = "Search Notes" },
      { "<leader>oq", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick Switch" },
    },
  },
  {
    "markdown-preview.nvim",
    ft = "markdown",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    after = function()
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "markdown-toc.nvim",
    ft = "markdown",
    cmd = { "Mtoc" },
    after = function()
      require("mtoc").setup({
        headings = { before_toc = false },
        toc_list = { markers = "-" },
      })
    end,
    keys = {
      { "<leader>mt", "<cmd>Mtoc<cr>", desc = "Markdown TOC" },
    },
  },
  {
    "presenting.nvim",
    ft = "markdown",
    cmd = { "Presenting" },
    after = function()
      require("presenting").setup()
    end,
    keys = {
      { "<leader>mp", "<cmd>Presenting<cr>", desc = "Presenting Mode" },
    },
  },
}
