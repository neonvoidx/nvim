{ lib, userPlugins, ... }:
{
  vim.utility.smart-splits = {
    enable = true;

    # nvf pins smart-splits v2.1.0 via npins; backend-kitty requires v3, so
    # the package is overridden below. v3 keeps the same move/resize API.
    setupOpts.mux.backend = "smart-splits-backend-kitty";

    keymaps = {
      move_cursor_left = "<C-h>";
      move_cursor_down = "<C-j>";
      move_cursor_up = "<C-k>";
      move_cursor_right = "<C-l>";
      resize_left = "<C-S-h>";
      resize_down = "<C-S-j>";
      resize_up = "<C-S-k>";
      resize_right = "<C-S-l>";
    };
  };

  vim.lazy.plugins = {
    smart-splits.package = lib.mkForce userPlugins.smart-splits;

    # smart-splits.setup() resolves mux.backend immediately (it require()s the
    # backend module), so the backend must already be on the runtimepath when
    # smart-splits loads on DeferredUIEnter. lz.n would otherwise load
    # lexicographic-order "smart-splits" first, so load this eagerly.
    smart-splits-backend-kitty = {
      package = userPlugins.smart-splits-backend-kitty;
      lazy = false;
    };
  };
}
