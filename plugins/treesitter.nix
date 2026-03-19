{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-ts-context-commentstring
      nvim-treesitter-endwise
    ];

    luaConfigRC."treesitter" = lib.nvim.dag.entryAnywhere ''
      require("nvim-treesitter.configs").setup({
        -- Grammars are provided by Nix; no auto-install needed
        auto_install = false,
        sync_install = false,
        ignore_install = {},
        modules = {},

        endwise = { enable = true },

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
      })

      require("treesitter-context").setup({
        enable = true,
        multiwindow = true,
        max_lines = 0,
        separator = "▔",
      })

      vim.keymap.set("n", "[c", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { desc = "Go to Treesitter context" })
    '';
  };
}
