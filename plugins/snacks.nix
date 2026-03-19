{ pkgs, lib, ... }:
{
  config.vim = {
    extraPackages = [ pkgs.lazygit ];

    utility.snacks-nvim = {
      enable = true;

      setupOpts = {
        animate = {
          enabled = true;
        };
        bigfile = {
          enabled = true;
        };
        dim = {
          enabled = true;
        };
        scope = {
          enabled = true;
        };
        rename = {
          enabled = true;
        };
        git = {
          enabled = false;
        };
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        quickfile = {
          enabled = true;
        };
        scroll = {
          enabled = true;
        };
        input = {
          enabled = true;
        };
        lazygit = {
          enabled = true;
        };

        statuscolumn = {
          enable = true;
          left = [ "sign" ];
          right = [
            "fold"
            "git"
            "mark"
          ];
          folds = {
            open = false;
            git_hl = true;
          };
        };

        indent = {
          enabled = true;
          hl = [
            "SnacksIndent1"
            "SnacksIndent2"
            "SnacksIndent3"
            "SnacksIndent4"
            "SnacksIndent5"
            "SnacksIndent6"
            "SnacksIndent7"
            "SnacksIndent8"
          ];
        };

        picker = {
          enabled = true;
          layout.layout = {
            backdrop = false;
            width = 0.80;
            min_width = 80;
            height = 0.80;
            min_height = 30;
            box = "vertical";
            border = true;
            title = "{title} {live} {flags}";
            title_pos = "center";
          };
        };

        dashboard = {
          enabled = true;
          preset.header = ''
            ░   ░░░  ░░        ░░░      ░░░  ░░░░  ░░        ░░  ░░░░  ░
            ▒    ▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒
            ▓  ▓  ▓  ▓▓      ▓▓▓▓  ▓▓▓▓  ▓▓▓  ▓▓  ▓▓▓▓▓▓  ▓▓▓▓▓        ▓
            █  ██    ██  ████████  ████  ████    ███████  █████  █  █  █
            █  ███   ██        ███      ██████  █████        ██  ████  █'';
          sections = [
            { section = "header"; }
            { section = "keys"; gap = 1; padding = 1; }
            { section = "recent_files"; gap = 1; padding = 1; }
            { section = "projects"; gap = 1; padding = 1; }
            { section = "startup"; }
          ];
        };
      };
    };

    # ── Keymaps and globals that depend on Snacks being loaded ───────────
    luaConfigRC."snacks-config" = lib.nvim.dag.entryAnywhere /* lua */ ''
      vim.api.nvim_set_hl(0, "SnacksDim", { link = "Comment" })

      vim.api.nvim_create_autocmd("User", {
        pattern  = "VeryLazy",
        callback = function()
          _G.dd  = function(...) Snacks.debug.inspect(...) end
          _G.bt  = function() Snacks.debug.backtrace() end
          vim.print = _G.dd

          Snacks.toggle.option("spell",         { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap",          { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber",{ name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel",
            { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background",
            { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })

      -- which-key group labels
      local wk = require("which-key")
      wk.add({
        { "<leader>f",  group = "+find",    icon = { icon = "󰍉 " } },
        { "<leader>g",  group = "+git",     icon = { icon = " " } },
        { "<leader>s",  group = "+search",  icon = { icon = "󰆘 " } },
        { "<leader>u",  group = "+ui",      icon = { icon = "󰍹 " } },
        { "<leader>c",  group = "+code",    icon = { icon = " " } },
        { "<leader>x",  group = "+trouble", icon = { icon = " " } },
      })

      -- Picker keymaps
      local map = vim.keymap.set
      map("n", "<leader><space>", function() Snacks.picker.smart() end,            { desc = "Smart Find Files" })
      map("n", "<leader>'",       function() Snacks.picker.buffers() end,           { desc = "Buffers" })
      map("n", "<leader>/",       function() Snacks.picker.grep() end,              { desc = "Grep" })
      map("n", "<leader>:",       function() Snacks.picker.command_history() end,   { desc = "Command History" })
      map("n", "<leader>fb",      function() Snacks.picker.buffers() end,           { desc = "Buffers" })
      map("n", "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
      map("n", "<leader>ff",      function() Snacks.picker.files() end,             { desc = "Find Files" })
      map("n", "<leader>fg",      function() Snacks.picker.git_files() end,         { desc = "Find Git Files" })
      map("n", "<leader>fp",      function() Snacks.picker.projects() end,          { desc = "Projects" })
      map("n", "<leader>fr",      function() Snacks.picker.recent() end,            { desc = "Recent" })
      map("n", "<leader>gb",      function() Snacks.picker.git_branches() end,      { desc = "Git Branches" })
      map("n", "<leader>gl",      function() Snacks.picker.git_log() end,           { desc = "Git Log" })
      map("n", "<leader>gL",      function() Snacks.picker.git_log_line() end,      { desc = "Git Log Line" })
      map("n", "<leader>gs",      function() Snacks.picker.git_status() end,        { desc = "Git Status" })
      map("n", "<leader>gS",      function() Snacks.picker.git_stash() end,         { desc = "Git Stash" })
      map("n", "<leader>gf",      function() Snacks.picker.git_log_file() end,      { desc = "Git Log File" })
      map("n", "<leader>sb",      function() Snacks.picker.lines() end,             { desc = "Buffer Lines" })
      map("n", "<leader>sB",      function() Snacks.picker.grep_buffers() end,      { desc = "Grep Open Buffers" })
      map("n", "<leader>sg",      function() Snacks.picker.grep() end,              { desc = "Grep" })
      map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end,    { desc = "Word/Selection" })
      map("n", '<leader>s"',      function() Snacks.picker.registers() end,         { desc = "Registers" })
      map("n", "<leader>s/",      function() Snacks.picker.search_history() end,    { desc = "Search History" })
      map("n", "<leader>sa",      function() Snacks.picker.autocmds() end,          { desc = "Autocmds" })
      map("n", "<leader>sc",      function() Snacks.picker.command_history() end,   { desc = "Command History" })
      map("n", "<leader>sC",      function() Snacks.picker.commands() end,          { desc = "Commands" })
      map("n", "<leader>sh",      function() Snacks.picker.help() end,              { desc = "Help Pages" })
      map("n", "<leader>sH",      function() Snacks.picker.highlights() end,        { desc = "Highlights" })
      map("n", "<leader>si",      function() Snacks.picker.icons() end,             { desc = "Icons" })
      map("n", "<leader>sj",      function() Snacks.picker.jumps() end,             { desc = "Jumps" })
      map("n", "<leader>sk",      function() Snacks.picker.keymaps() end,           { desc = "Keymaps" })
      map("n", "<leader>sl",      function() Snacks.picker.loclist() end,           { desc = "Location List" })
      map("n", "<leader>sm",      function() Snacks.picker.marks() end,             { desc = "Marks" })
      map("n", "<leader>sM",      function() Snacks.picker.man() end,               { desc = "Man Pages" })
      map("n", "<leader>sq",      function() Snacks.picker.qflist() end,            { desc = "Quickfix List" })
      map("n", "<leader>sR",      function() Snacks.picker.resume() end,            { desc = "Resume" })
      map("n", "<leader>su",      function() Snacks.picker.undo() end,              { desc = "Undo History" })
      map("n", "<leader>uC",      function() Snacks.picker.colorschemes() end,      { desc = "Colorschemes" })
      map("n", "<leader>st",      function() Snacks.picker.todo_comments() end,     { desc = "Todo" })
      map("n", "<leader>sT",      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
      end, { desc = "Todo/Fix/Fixme" })
      map("n", "gd",  function() Snacks.picker.lsp_definitions() end,       { desc = "Goto Definition" })
      map("n", "gD",  function() Snacks.picker.lsp_declarations() end,      { desc = "Goto Declaration" })
      map("n", "gr",  function() Snacks.picker.lsp_references() end,        { desc = "References", nowait = true })
      map("n", "gI",  function() Snacks.picker.lsp_implementations() end,   { desc = "Goto Implementation" })
      map("n", "gy",  function() Snacks.picker.lsp_type_definitions() end,  { desc = "Goto Type Definition" })
      map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end,    { desc = "LSP Symbols" })
      map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
      map("n", "<leader>z",  function() Snacks.zen() end,                   { desc = "Toggle Zen Mode" })
      map("n", "<leader>Z",  function() Snacks.zen.zoom() end,              { desc = "Toggle Zoom" })
      map("n", "<leader>..", function() Snacks.scratch() end,               { desc = "Toggle Scratch Buffer" })
      map("n", "<leader>.s", function() Snacks.scratch.select() end,        { desc = "Select Scratch Buffer" })
      map("n", "<leader>nn", function() Snacks.notifier.show_history() end, { desc = "Notification History" })
      map("n", "<leader>nd", function() Snacks.notifier.hide() end,         { desc = "Notifications hide" })
      map("n", "<leader>un", function() Snacks.notifier.hide() end,         { desc = "Dismiss All Notifications" })
      map("n", "<leader>bd", function() Snacks.bufdelete() end,             { desc = "Delete Buffer" })
      map("n", "<leader>cR", function() Snacks.rename.rename_file() end,    { desc = "Rename File" })
      map({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end,    { desc = "Git Browse" })
      map("n", "<leader>gg", function() Snacks.lazygit() end,               { desc = "Lazygit" })
      map({ "n", "i", "t" }, "<c-/>", function() Snacks.terminal() end,    { desc = "Toggle Terminal" })
      map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end,  { desc = "Next Reference" })
      map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })
    '';
  };
}
