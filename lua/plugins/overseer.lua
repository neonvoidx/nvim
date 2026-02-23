return {
  "stevearc/overseer.nvim",
  opts = {
    templates = {
      "builtin",
      -- "user.cpp_build",
    },
  },
  keys = {
    { "<leader>Or", "<cmd>OverseerRun<cr>", desc = "Run Task" },
    { "<leader>Ol", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
  },
}
