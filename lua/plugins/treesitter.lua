return {
  {
    "nvim-treesitter",
    lazy = false,
    after = function()
      -- nvim-treesitter v1 API: setup just configures install_dir
      -- Highlight is handled by neovim's built-in treesitter
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- On non-nix: install parsers via TSInstall
      -- On nix: withAllGrammars provides all parsers; auto_install not available
      if not nixInfo.isNix then
        -- Set up the old-style highlights/ensure_installed via :TSInstall
        -- (v1 API doesn't have configs.setup; just install parsers)
        local parsers = {
          "css", "latex", "scss", "svelte", "typst", "vue",
          "bash", "c", "cpp", "cmake", "diff", "html",
          "javascript", "jsdoc", "json", "jsonc", "lua", "luadoc",
          "luap", "markdown", "markdown_inline", "printf", "python",
          "query", "regex", "toml", "tsx", "typescript", "vim",
          "vimdoc", "xml", "yaml",
        }
        vim.defer_fn(function()
          for _, lang in ipairs(parsers) do
            pcall(vim.cmd, "TSInstall " .. lang)
          end
        end, 1000)
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
