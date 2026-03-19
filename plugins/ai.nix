{ pkgs, lib, ... }:
{
  config.vim = {
    startPlugins = with pkgs.vimPlugins; [
      copilot-lua
    ];

    luaConfigRC."ai" = lib.nvim.dag.entryAnywhere /* lua */ ''
      -- ── GitHub Copilot ────────────────────────────────────────────────
      require("copilot").setup({
        filetypes = {
          markdown = false,
          help = false,
          sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
              return false
            end
            return true
          end,
        },
        nes = { enabled = false },
      })
    '';
  };
}
