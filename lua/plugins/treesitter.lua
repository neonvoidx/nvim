return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "RRethy/nvim-treesitter-endwise", -- Auto adds `end` to things like lua functions
      "JoosepAlviste/nvim-ts-context-commentstring", -- Allows commenting in things like HTML inside Vue etc
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          enable = true,
          multiwindow = true,
          max_lines = 0,
          separator = "▔",
        },
        keys = {
          {
            "[c",
            function()
              require("treesitter-context").go_to_context(vim.v.count1)
            end,
            { desc = "Go to Treesitter context" },
          },
        },
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        ensure_installed = {
          "css",
          "latex",
          "norg",
          "scss",
          "svelte",
          "typst",
          "vue",
          "bash",
          "c",
          "cpp",
          "cmake",
          "diff",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "printf",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
        },
      })
    end,
  },
}
