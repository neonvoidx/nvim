{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      flash-nvim
      mini-nvim           # provides mini.pairs and mini.surround
      todo-comments-nvim
      nvim-scissors
      nvim-highlight-colors
      numb-nvim
      overseer-nvim
      quicker-nvim
      guess-indent-nvim
      nvim-web-devicons
    ];

    luaConfigRC."editing" = lib.nvim.dag.entryAnywhere ''
      -- ── Flash (motion) ────────────────────────────────────────────────
      require("flash").setup({
        auto_jump = true,
        multi_window = false,
      })
      local map = vim.keymap.set
      map({ "n", "x", "o" }, "s", function() require("flash").jump() end,              { desc = "Flash" })
      map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end,        { desc = "Flash Treesitter" })
      map("o",               "r", function() require("flash").remote() end,             { desc = "Remote Flash" })
      map({ "o", "x" },      "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
      map("c",               "<c-s>", function() require("flash").toggle() end,        { desc = "Toggle Flash Search" })

      -- ── Mini.pairs (auto-pairs) ───────────────────────────────────────
      require("mini.pairs").setup({
        modes = { insert = true, command = false, terminal = false },
      })

      -- ── Mini.surround ─────────────────────────────────────────────────
      require("mini.surround").setup({
        mappings = {
          add           = "gsa",
          delete        = "gsd",
          find          = "gsf",
          find_left     = "gsF",
          highlight     = "gsh",
          replace       = "gsr",
          update_n_lines = "gsn",
        },
      })

      -- ── Todo-comments ─────────────────────────────────────────────────
      require("todo-comments").setup({
        signs = true,
        merge_keywords = false,
        keywords = {
          BUG    = { icon = "", color = "error" },
          FIXME  = { icon = "", color = "error" },
          fixme  = { icon = "", color = "error" },
          HACK   = { icon = "", color = "info" },
          NOTE   = { icon = "❦", color = "info" },
          note   = { icon = "❦", color = "info" },
          TODO   = { icon = "★", color = "actionItem" },
          todo   = { icon = "★", color = "actionItem" },
          WARN    = { icon = "󰀦", color = "warning" },
          warn    = { icon = "󰀦", color = "warning" },
          WARNING = { icon = "󰀦", color = "warning" },
        },
        colors = {
          actionItem = { "ActionItem", "#f1fc79" },
          default    = { "Identifier", "#37f499" },
          error      = { "LspDiagnosticsDefaultError", "ErrorMsg", "#f16c75" },
          info       = { "LspDiagnosticsDefaultInformation", "#ebfafa" },
          warning    = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#f7c67f" },
        },
        highlight = {
          keyword = "bg",
          pattern = [[.*<(KEYWORDS)\s*]],
        },
        search = {
          command = "rg",
          args = { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column" },
          pattern = [[\b(KEYWORDS)\b]],
        },
      })

      -- ── nvim-highlight-colors ─────────────────────────────────────────
      require("nvim-highlight-colors").setup({ render = "virtual" })

      -- ── Numb (line number peek) ───────────────────────────────────────
      require("numb").setup()

      -- ── Overseer (task runner) ────────────────────────────────────────
      require("overseer").setup({ templates = { "builtin" } })
      map("n", "<leader>or", "<cmd>OverseerRun<cr>",    { desc = "Run Task" })
      map("n", "<leader>ol", "<cmd>OverseerToggle<cr>", { desc = "Toggle Task List" })

      -- ── Quicker (quickfix enhancements) ──────────────────────────────
      require("quicker").setup({
        keys = {
          { ">", function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
            desc = "Expand quickfix context" },
          { "<", function() require("quicker").collapse() end, desc = "Collapse quickfix context" },
        },
      })
      map("n", "<leader>q", function() require("quicker").toggle() end, { desc = "Toggle quickfix" })

      -- ── Guess indent ─────────────────────────────────────────────────
      require("guess-indent").setup()
    '';
  };
}
