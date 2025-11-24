return {
  "stevearc/oil.nvim",
  vscode = false,
  -- config = function(_, opts)
  --   vim.api.nvim_create_autocmd("User", {
  --     pattern = "OilActionsPost",
  --     callback = function(event)
  --       if event.data.actions.type == "move" then
  --         require("snacks").rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
  --       end
  --     end,
  --   })
  -- end,
  opts = {
    columns = {
      "icon",
    },
    default_file_explorer = true,
    delete_to_trash = false,
    prompt_save_on_select_new_entry = false,
    skip_confirm_for_simple_edits = true,
    cleanup_delay_ms = 2000,
    enabled = false,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 1000,
      autosave_changes = true,
    },
    constrain_cursor = "editable",
    watch_for_changes = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        -- local ignored = { ".git", ".hg", ".svn", ".DS_Store", "node_modules" }
        -- if vim.tbl_contains(ignored, name) then
        --   return true
        -- else
        --   return false
        -- end
      end,
      natural_order = "fast",
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["q"] = "actions.close",
      ["<C-k>"] = "actions.parent",
      ["gv"] = "actions.select_vsplit",
      ["gh"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["gr"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["<C-o>"] = "actions.open_external",
      ["H"] = "actions.toggle_hidden",
      ["T"] = "actions.toggle_trash",
      ["<C-q>"] = "actions.send_to_qflist",
    },
    float = {
      border="rounded",
      max_width = 0.8,
      min_width = 0.8,
      win_options = {
        winblend = 0,
      },
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        require("oil").toggle_float()
      end,
      desc = "Oil",
    },
    {
      "<leader>E",
      function()
        require("oil").toggle_float(vim.cmd("pwd"))
      end,
      desc = "Oil (root dir)",
    },
    {
      "<C-s>",
      function()
        require("oil").save()
      end,
      desc = "Save oil changes",
      ft = "oil",
    },
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}
