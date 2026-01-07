local nixCatsUtils = require("nixCatsUtils")

-- When using NixCats, plugins are provided by Nix via optionalPlugins
if nixCatsUtils.isNixCats then
  return {
    {
      "nvim-treesitter/nvim-treesitter",
      dir = nixCats.pawsible.allPlugins.opt["nvim-treesitter"],
      build = false,
      lazy = false,
    },
    {
      "RRethy/nvim-treesitter-endwise",
      dir = nixCats.pawsible.allPlugins.opt["nvim-treesitter-endwise"],
      build = false,
      lazy = false,
    },
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      dir = nixCats.pawsible.allPlugins.opt["nvim-ts-context-commentstring"],
      build = false,
      lazy = false,
    },
    {
      "nvim-treesitter/nvim-treesitter-context",
      dir = nixCats.pawsible.allPlugins.opt["nvim-treesitter-context"],
      build = false,
      lazy = false,
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
          desc = "Go to Treesitter context",
        },
      },
    },
  }
end

-- When NOT using Nix, lazy.nvim manages everything
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
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
          additional_vim_regex_highlighting = false,
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
  {
    "RRethy/nvim-treesitter-endwise",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    lazy = false,
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
        desc = "Go to Treesitter context",
      },
    },
  },
}
