return {
  {
    "quicker.nvim",
    ft = "qf",
    after = function()
      vim.keymap.set("n", "<leader>q", function()
        require("quicker").toggle()
      end, { desc = "Toggle quickfix" })

      require("quicker").setup({
        keys = {
          {
            ">",
            function()
              require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
          },
          {
            "<",
            function()
              require("quicker").collapse()
            end,
            desc = "Collapse quickfix context",
          },
        },
      })
    end,
  },
}
