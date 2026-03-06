return {
  {
    "snacks.nvim",
    lazy = false,
    priority = 1000,
    beforeAll = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd

          local wk = require("which-key")
          wk.add({
            { "<leader>f", group = "+find",   icon = { icon = "󰍉 " } },
            { "<leader>g", group = "+git",    icon = { icon = " " } },
            { "<leader>s", group = "+snacks", icon = { icon = "󰆘 " } },
            { "<leader>u", group = "+ui",     icon = { icon = "󰍹 " } },
          })

          Snacks.toggle.option("spell",          { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap",           { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel",   { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background",     { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
    after = function()
      require("snacks").setup({
        animate      = { enabled = true },
        bigfile      = { enabled = true },
        dim          = { enabled = true },
        scope        = { enabled = true },
        rename       = { enabled = true },
        git          = { enabled = false },
        input        = { enabled = true },
        lazygit      = { enabled = true },
        quickfile    = { enabled = true },
        scroll       = { enabled = true },
        words        = { enabled = true },
        notifier     = { enabled = true, timeout = 3000 },
        styles       = { notification = { wo = { wrap = true } } },
        toggle       = { which_key = true, notify = true },
        image = {
          resolve = function(path, src)
            local ok, obsidian_api = pcall(require, "obsidian.api")
            if ok and obsidian_api.path_is_note(path) then
              return obsidian_api.resolve_image_path(src)
            end
          end,
        },
        statuscolumn = {
          enable = true,
          left   = { "sign" },
          right  = { "fold", "git", "mark" },
          folds  = { open = false, git_hl = true },
        },
        indent = {
          enabled = true,
          hl = {
            "SnacksIndent1", "SnacksIndent2", "SnacksIndent3", "SnacksIndent4",
            "SnacksIndent5", "SnacksIndent6", "SnacksIndent7", "SnacksIndent8",
          },
        },
        picker = {
          enabled = true,
          formatters = { file = { filename_first = true } },
          layout = {
            layout = {
              backdrop  = false,
              width     = 0.80,
              min_width = 80,
              height    = 0.80,
              min_height = 30,
              box        = "vertical",
              border     = true,
              title      = "{title} {live} {flags}",
              title_pos  = "center",
              { win = "input",   height = 1,   border = "bottom" },
              { win = "list",    border = "none", height = 0.4, wo = { wrap = true } },
              { win = "preview", title = "{preview}", height = 0.6, border = "top" },
            },
          },
          actions = {
            qflist_append = function(picker)
              picker:close()
              local sel   = picker:selected()
              local items = #sel > 0 and sel or picker:items()
              local qf    = {} ---@type vim.quickfix.entry[]
              for _, item in ipairs(items) do
                qf[#qf + 1] = {
                  filename = Snacks.picker.util.path(item),
                  bufnr    = item.buf,
                  lnum     = item.pos and item.pos[1] or 1,
                  col      = item.pos and item.pos[2] + 1 or 1,
                  end_lnum = item.end_pos and item.end_pos[1] or nil,
                  end_col  = item.end_pos and item.end_pos[2] + 1 or nil,
                  text     = item.line or item.comment or item.label or item.name or item.detail or item.text,
                  pattern  = item.search,
                  valid    = true,
                }
              end
              vim.fn.setqflist(qf, "a")
              vim.cmd("botright copen")
            end,
          },
          win = {
            input = {
              keys = {
                ["<c-q>"] = { "qflist_append", mode = { "n", "i" } },
              },
            },
          },
        },
        dashboard = {
          enabled = true,
          preset = {
            header = [[
░   ░░░  ░░        ░░░      ░░░  ░░░░  ░░        ░░  ░░░░  ░
▒    ▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒
▓  ▓  ▓  ▓▓      ▓▓▓▓  ▓▓▓▓  ▓▓▓  ▓▓  ▓▓▓▓▓▓  ▓▓▓▓▓        ▓
█  ██    ██  ████████  ████  ████    ███████  █████  █  █  █
█  ███   ██        ███      ██████  █████        ██  ████  █
]],
            keys = {
              { icon = " ", key = "f", desc = "Find File",       action = ":lua Snacks.picker.files()" },
              { icon = " ", key = "n", desc = "New File",        action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text",       action = ":lua Snacks.picker.grep()" },
              { icon = " ", key = "r", desc = "Recent Files",    action = ":lua Snacks.picker.recent()" },
              { icon = " ", key = "s", desc = "Restore Session", action = function()
                  vim.cmd.packadd("persistence.nvim")
                  require("persistence").load()
                end },
              { icon = "󰒲 ", key = "l", desc = "Lazy",           action = ":Lazy",   enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
            },
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            {
              pane    = 2,
              icon    = " ",
              title   = "Recent Files",
              section = "recent_files",
              indent  = 2,
              padding = 1,
              cwd     = true,
              limit   = 5,
            },
            {
              pane    = 2,
              icon    = " ",
              title   = "Git Status",
              section = "terminal",
              enabled = function() return Snacks.git.get_root() ~= nil end,
              cmd     = "git status --short --branch --renames",
              height  = 5,
              padding = 1,
              ttl     = 5 * 60,
              indent  = 3,
            },
            function()
              local in_git = Snacks.git.get_root() ~= nil
              return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                  pane    = 2,
                  section = "terminal",
                  enabled = in_git,
                  padding = 1,
                  ttl     = 60,
                  indent  = 3,
                }, cmd)
              end, {
                { icon = " ", title = "Git Diff", cmd = "git --no-pager diff --stat -B -M -C", height = 10 },
              })
            end,
          },
        },
      })
      vim.api.nvim_set_hl(0, "SnacksDim", { link = "Comment" })
      _G.Snacks = require("snacks")
    end,
    keys = {
      -- Pickers
      {
        "<leader><space>",
        function() Snacks.picker.smart() end,
        desc = "Smart Find Files",
      },
      {
        "<leader>'",
        function() Snacks.picker.buffers() end,
        desc = "Buffers",
      },
      {
        "<leader>,",
        function() Snacks.picker.buffers() end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function() Snacks.picker.grep() end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function() Snacks.picker.command_history() end,
        desc = "Command History",
      },
      -- find
      {
        "<leader>fb",
        function() Snacks.picker.buffers() end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function() Snacks.picker.files() end,
        desc = "Find Files",
      },
      {
        "<leader>fF",
        function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader>fg",
        function() Snacks.picker.git_files() end,
        desc = "Find Git Files",
      },
      {
        "<leader>fp",
        function() Snacks.picker.projects() end,
        desc = "Projects",
      },
      {
        "<leader>fr",
        function() Snacks.picker.recent() end,
        desc = "Recent",
      },
      {
        "<leader>fR",
        function() Snacks.picker.recent({ filter = { cwd = true } }) end,
        desc = "Recent (cwd)",
      },
      -- git
      {
        "<leader>gb",
        function() Snacks.picker.git_branches() end,
        desc = "Git Branches",
      },
      {
        "<leader>gl",
        function() Snacks.picker.git_log() end,
        desc = "Git Log",
      },
      {
        "<leader>gL",
        function() Snacks.picker.git_log_line() end,
        desc = "Git Log Line",
      },
      {
        "<leader>gG",
        function() Snacks.picker.git_log() end,
        desc = "Git Log",
      },
      {
        "<leader>gs",
        function() Snacks.picker.git_status() end,
        desc = "Git Status",
      },
      {
        "<leader>gS",
        function() Snacks.picker.git_stash() end,
        desc = "Git Stash",
      },
      {
        "<leader>gd",
        function() Snacks.picker.git_diff() end,
        desc = "Git Diff (Hunks)",
      },
      {
        "<leader>gf",
        function() Snacks.picker.git_log_file() end,
        desc = "Git Log File",
      },
      {
        "<leader>gB",
        function() Snacks.gitbrowse() end,
        mode = { "n", "v" },
        desc = "Git Browse",
      },
      {
        "<leader>gg",
        function() Snacks.lazygit() end,
        desc = "Lazygit",
      },
      -- search
      {
        '<leader>s"',
        function() Snacks.picker.registers() end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function() Snacks.picker.search_history() end,
        desc = "Search History",
      },
      {
        "<leader>sa",
        function() Snacks.picker.autocmds() end,
        desc = "Autocmds",
      },
      {
        "<leader>sb",
        function() Snacks.picker.lines() end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function() Snacks.picker.grep_buffers() end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sc",
        function() Snacks.picker.command_history() end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function() Snacks.picker.commands() end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function() Snacks.picker.diagnostics() end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function() Snacks.picker.diagnostics({ filter = { buf = 0 } }) end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sg",
        function() Snacks.picker.grep() end,
        desc = "Grep",
      },
      {
        "<leader>sG",
        function() Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") }) end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>sh",
        function() Snacks.picker.help() end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function() Snacks.picker.highlights() end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function() Snacks.picker.icons() end,
        desc = "Icons",
      },
      {
        "<leader>sj",
        function() Snacks.picker.jumps() end,
        desc = "Jumps",
      },
      {
        "<leader>sk",
        function() Snacks.picker.keymaps() end,
        desc = "Keymaps",
      },
      {
        "<leader>sl",
        function() Snacks.picker.loclist() end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function() Snacks.picker.marks() end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function() Snacks.picker.man() end,
        desc = "Man Pages",
      },
      {
        "<leader>sq",
        function() Snacks.picker.qflist() end,
        desc = "Quickfix List",
      },
      {
        "<leader>sR",
        function() Snacks.picker.resume() end,
        desc = "Resume",
      },
      {
        "<leader>su",
        function() Snacks.picker.undo() end,
        desc = "Undo History",
      },
      {
        "<leader>sw",
        function() Snacks.picker.grep_word() end,
        mode = { "n", "x" },
        desc = "Visual selection or word",
      },
      {
        "<leader>ss",
        function() Snacks.picker.lsp_symbols() end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function() Snacks.picker.lsp_workspace_symbols() end,
        desc = "LSP Workspace Symbols",
      },
      -- lsp
      {
        "gd",
        function() Snacks.picker.lsp_definitions() end,
        desc = "Goto Definition",
      },
      {
        "gD",
        function() Snacks.picker.lsp_declarations() end,
        desc = "Goto Declaration",
      },
      {
        "gI",
        function() Snacks.picker.lsp_implementations() end,
        desc = "Goto Implementation",
      },
      {
        "gr",
        function() Snacks.picker.lsp_references() end,
        nowait = true,
        desc = "References",
      },
      {
        "gy",
        function() Snacks.picker.lsp_type_definitions() end,
        desc = "Goto T[y]pe Definition",
      },
      -- ui
      {
        "<leader>uC",
        function() Snacks.picker.colorschemes() end,
        desc = "Colorschemes",
      },
      -- other
      {
        "<leader>nn",
        function() Snacks.notifier.show_history() end,
        desc = "Notification History",
      },
      {
        "<leader>n",
        function() Snacks.picker.notifications() end,
        desc = "Notifications",
      },
      {
        "<leader>nd",
        function() Snacks.notifier.hide() end,
        desc = "Notifications Dismiss",
      },
      {
        "<leader>un",
        function() Snacks.notifier.hide() end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>bd",
        function() Snacks.bufdelete() end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bo",
        function() Snacks.bufdelete.other() end,
        desc = "Delete Other Buffers",
      },
      {
        "<leader>cR",
        function() Snacks.rename.rename_file() end,
        desc = "Rename File",
      },
      {
        "<leader>z",
        function() Snacks.zen() end,
        desc = "Toggle Zen Mode",
      },
      {
        "<leader>Z",
        function() Snacks.zen.zoom() end,
        desc = "Toggle Zoom",
      },
      {
        "<leader>..",
        function() Snacks.scratch() end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>.s",
        function() Snacks.scratch.select() end,
        desc = "Select Scratch Buffer",
      },
      {
        "<c-/>",
        function() Snacks.terminal() end,
        desc = "Toggle Terminal",
      },
      {
        "<c-_>",
        function() Snacks.terminal() end,
        desc = "which_key_ignore",
      },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        mode = { "n", "t" },
        desc = "Next Reference",
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        mode = { "n", "t" },
        desc = "Prev Reference",
      },
      {
        "<leader>N",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = { spell = false, wrap = false, signcolumn = "yes", statuscolumn = " ", conceallevel = 3 },
          })
        end,
        desc = "Neovim News",
      },
    },
  },
}
