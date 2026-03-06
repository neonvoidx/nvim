return {
  {
    "overseer.nvim",
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>",    desc = "Run Task" },
      { "<leader>ol", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
    },
    cmd = { "OverseerRun", "OverseerToggle" },
    after = function()
      require("overseer").setup({ templates = { "builtin" } })
    end,
  },
}
