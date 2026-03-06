return {
  {
    "nvim-treesitter",
    lazy = false,
    after = function()
      -- nvim-treesitter v1 API: setup just configures install_dir
      -- Highlight is handled by neovim's built-in treesitter
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- Non-nix: prefer automatic parser installation instead of manually
      -- enumerating parsers. Nix: parsers are typically pre-provided.
      if not nixInfo.isNix then
        -- nvim-treesitter v1 exposes its config via `nvim-treesitter.configs`.
        -- `auto_install` installs missing parsers when entering a buffer.
        pcall(function()
          require("nvim-treesitter.configs").setup({
            auto_install = true,
          })
        end)
      end

      -- Enable endwise (nvim-treesitter-endwise integration)
      local ok_endwise = pcall(require, "nvim-treesitter-endwise")
      if ok_endwise then
        vim.api.nvim_create_autocmd("FileType", {
          callback = function(ev)
            pcall(require("nvim-treesitter-endwise").attach, ev.buf)
          end,
        })
      end
    end,
  },
  {
    "nvim-treesitter-context",
    lazy = false,
    after = function()
      require("treesitter-context").setup({
        enable = true,
        multiwindow = true,
        max_lines = 0,
        separator = "▔",
      })
    end,
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
