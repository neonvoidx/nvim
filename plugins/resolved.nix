{
  userPlugins,
  pkgs,
  lib,
  ...
}:
{
  config.vim = {
    # resolved.nvim drives everything through the `gh` CLI, so it has to be on
    # PATH. The user still needs to run `gh auth login` once.
    extraPackages = [ pkgs.gh ];

    startPlugins = [ userPlugins.resolved-nvim ];

    luaConfigRC."resolved" = lib.nvim.dag.entryAnywhere /* lua */ ''
      local resolved = require("resolved")

      resolved.setup({
        cache_ttl = 300,
        debounce_ms = 500,
        include_prs = true,
        -- Match the todo-comments keyword set in editing.nix so a comment that
        -- shows up highlighted there can also go stale here.
        stale_keywords = {
          "BUG",
          "FIXME",
          "HACK",
          "NOTE",
          "TODO",
          "WARN",
          "XXX",
          "WA",
          "workaround",
          "temporary",
          "temp",
          "WIP",
          "blocked",
          "waiting",
          "upstream",
        },
      })

      local map = vim.keymap.set

      map("n", "<leader>gpi", function()
        require("resolved.picker").show_issues_picker()
      end, { desc = "Issue and PR picker" })
      map("n", "<leader>gpR", function() resolved.refresh() end,    { desc = "Refresh issue status" })
      map("n", "<leader>gpt", function() resolved.toggle() end,      { desc = "Toggle issue status" })
      map("n", "<leader>gpc", function() resolved.clear_cache() end, { desc = "Clear issue cache" })
    '';
  };
}
