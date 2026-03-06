return {
  {
    "snacks.nvim",
    lazy = false,
    priority = 1000,
    beforeAll = function()
      -- Global Snacks reference available early (before full load)
      _G.Snacks = require("snacks")
    end,
    after = function()
      require("snacks").setup({
        bigfile = { enabled = true },
        quickfile = { enabled = true },
        indent = {
          enabled = true,
          animate = { enabled = false },
        },
        input = { enabled = true },
        notifier = {
          enabled = true,
          timeout = 3000,
        },
        picker = {
          enabled = true,
          layout = {
            preset = "ivy",
          },
          formatters = {
            file = { filename_first = true },
          },
          layouts = {
            ivy = {
              layout = {
                box = "vertical",
                backdrop = false,
                row = -1,
                width = 0,
                height = 0.5,
                border = "top",
                title = " {title} {live} {flags}",
                title_pos = "left",
                { win = "input",   height = 1, border = "bottom" },
                { win = "list",    border = "none" },
                { win = "preview", title = "{preview}", border = "left", width = 0.5 },
              },
            },
          },
          win = {
            input = {
              keys = {
                ["<c-j>"] = { "list_down", mode = { "i", "n" } },
                ["<c-k>"] = { "list_up", mode = { "i", "n" } },
                ["<c-l>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-h>"] = { "preview_scroll_up", mode = { "i", "n" } },
              },
            },
          },
        },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
          notification = { wo = { wrap = true } },
        },
        toggle = {
          which_key = true,
          notify = true,
        },
        dashboard = {
          enabled = true,
          preset = {
            header = [[
███╗   ██╗██╗██╗  ██╗    ██╗   ██╗███╗   ███╗
████╗  ██║██║╚██╗██╔╝    ██║   ██║████╗ ████║
██╔██╗ ██║██║ ╚███╔╝     ██║   ██║██╔████╔██║
██║╚██╗██║██║ ██╔██╗     ╚██╗ ██╔╝██║╚██╔╝██║
██║ ╚████║██║██╔╝ ██╗     ╚████╔╝ ██║ ╚═╝ ██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝     ╚═══╝  ╚═╝     ╚═╝]],
          },
          sections = {
            { section = "header" },
            {
              icon = " ",
              title = "Keymaps",
              section = "keys",
              indent = 2,
              padding = 1,
            },
            {
              icon = " ",
              title = "Recent Files",
              section = "recent_files",
              indent = 2,
              padding = 1,
            },
            {
              icon = " ",
              title = "Projects",
              section = "projects",
              indent = 2,
              padding = 1,
            },
            { section = "startup" },
          },
        },
      })
    end,
    keys = {
      -- Pickers
      { "<leader><space>", function() Snacks.picker.smart()        end, desc = "Smart Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers()      end, desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep()         end, desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
      -- find
      { "<leader>ff", function() Snacks.picker.files()             end, desc = "Find Files" },
      { "<leader>fF", function() Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files()         end, desc = "Find Git Files" },
      { "<leader>fr", function() Snacks.picker.recent()            end, desc = "Recent" },
      { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = "Recent (cwd)" },
      -- git
      { "<leader>gb", function() Snacks.picker.git_branches()     end, desc = "Git Branches" },
      { "<leader>gG", function() Snacks.picker.git_log()          end, desc = "Git Log" },
      { "<leader>gl", function() Snacks.picker.git_log_line()     end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status()       end, desc = "Git Status" },
      -- search
      { '<leader>s"', function() Snacks.picker.registers()        end, desc = "Registers" },
      { "<leader>sa", function() Snacks.picker.autocmds()         end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines()            end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers()     end, desc = "Grep Open Buffers" },
      { "<leader>sc", function() Snacks.picker.command_history()  end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands()         end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics()      end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics({ filter = { buf = 0 } }) end, desc = "Buffer Diagnostics" },
      { "<leader>sg", function() Snacks.picker.grep()             end, desc = "Grep" },
      { "<leader>sG", function() Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Grep (cwd)" },
      { "<leader>sh", function() Snacks.picker.help()             end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights()       end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons()            end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps()            end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps()          end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist()          end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks()            end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man()              end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy()             end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist()           end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume()           end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo()             end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes()     end, desc = "Colorschemes" },
      { "<leader>sw", function() Snacks.picker.grep_word()        end, mode = { "n", "x" }, desc = "Visual selection or word" },
      -- lsp
      { "gd",  function() Snacks.picker.lsp_definitions()         end, desc = "Goto Definition" },
      { "gD",  function() Snacks.picker.lsp_declarations()        end, desc = "Goto Declaration" },
      { "gI",  function() Snacks.picker.lsp_implementations()     end, desc = "Goto Implementation" },
      { "gr",  function() Snacks.picker.lsp_references()          end, nowait = true, desc = "References" },
      { "gy",  function() Snacks.picker.lsp_type_definitions()    end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols()      end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- other
      { "<leader>n",  function() Snacks.picker.notifications()    end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide()           end, desc = "Dismiss All Notifications" },
      { "<leader>bd", function() Snacks.bufdelete()               end, desc = "Delete Buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other()         end, desc = "Delete Other Buffers" },
      { "]]",         function() Snacks.words.jump(vim.v.count1)  end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      {
        "<leader>N",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6, height = 0.6,
            wo = { spell = false, wrap = false, signcolumn = "yes", statuscolumn = " ", conceallevel = 3 },
          })
        end,
        desc = "Neovim News",
      },
    },
  },
}
