local snippet_path = vim.fn.stdpath("config") .. "/snippets"

return {
  {
    "nvim-web-devicons",
    lazy = false,
  },
  {
    "blink.cmp",
    lazy = false,
    after = function()
      vim.cmd.packadd("blink-copilot")
      vim.cmd.packadd("lazydev.nvim")
      require("blink.cmp").setup({
        enabled = function()
          return not vim.tbl_contains({ "oil" }, vim.bo.filetype) and vim.bo.buftype ~= "prompt"
        end,
        fuzzy = {
          sorts = { "exact", "score", "sort_text" },
        },
        sources = {
          default = { "copilot", "lsp", "path", "lazydev", "snippets", "buffer" },
          providers = {
            path = {
              name = "path",
              opts = {
                get_cwd = function(_)
                  return vim.fn.getcwd()
                end,
              },
              score_offset = 5,
            },
            copilot = {
              name = "copilot",
              module = "blink-copilot",
              score_offset = 4,
              async = true,
            },
            lazydev = {
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 6,
            },
            lsp = {
              name = "LSP",
              module = "blink.cmp.sources.lsp",
              score_offset = 7,
            },
            snippets = {
              name = "snippets",
              opts = { search_paths = { snippet_path } },
              score_offset = 3,
            },
          },
          per_filetype = {
            codecompanion = { "codecompanion" },
          },
        },
        completion = {
          menu = {
            min_width = 60,
            border = "rounded",
            draw = {
              padding = { 0, 1 },
              columns = { { "kind_icon", gap = 1 }, { "label", "label_description" }, { "source_name" } },
              components = {
                kind_icon = {
                  text = function(ctx)
                    local icon = ctx.kind_icon
                    if vim.tbl_contains({ "path" }, ctx.source_name) then
                      local ok, devicons = pcall(require, "nvim-web-devicons")
                      if ok then
                        local dev_icon = devicons.get_icon(ctx.label)
                        if dev_icon then icon = dev_icon end
                      end
                    else
                      local ok, lspkind = pcall(require, "lspkind")
                      if ok then icon = lspkind.symbolic(ctx.kind, { mode = "symbol" }) end
                    end
                    local override_icons = { copilot = "", ripgrep = "", snippets = "" }
                    if override_icons[ctx.source_name] then
                      return override_icons[ctx.source_name] .. ctx.icon_gap
                    end
                    return icon .. ctx.icon_gap
                  end,
                  highlight = function(ctx)
                    local hl = ctx.kind_hl
                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                      local ok, devicons = pcall(require, "nvim-web-devicons")
                      if ok then
                        local _, dev_hl = devicons.get_icon(ctx.label)
                        if dev_hl then hl = dev_hl end
                      end
                    end
                    return hl
                  end,
                },
                label_description = { width = { fill = true } },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 500,
            window = { border = "rounded" },
          },
          trigger = { prefetch_on_insert = false },
          list = {
            selection = { preselect = true, auto_insert = true },
          },
        },
        keymap = {
          ["<C-k>"]     = { "select_prev", "fallback" },
          ["<C-j>"]     = { "select_next", "fallback" },
          ["<Tab>"]     = { "accept", "fallback" },
          ["<C-l>"]     = { "scroll_documentation_up", "fallback" },
          ["<C-h>"]     = { "scroll_documentation_down", "fallback" },
          ["<Up>"]      = { "select_prev", "fallback" },
          ["<Down>"]    = { "select_next", "fallback" },
          ["<S-Tab>"]   = { "snippet_forward", "fallback" },
          ["<C-Tab>"]   = { "snippet_backward", "fallback" },
          ["<C-e>"]     = { "hide", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        },
      })
    end,
  },
}
