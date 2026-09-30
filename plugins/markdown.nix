{ lib, ... }:
{
  config.vim = {
    languages.markdown.extensions.render-markdown-nvim = {
      enable = true;
      setupOpts = {
        file_types = [
          "markdown"
          "codecompanion"
        ];
        anti_conceal = {
          enabled = true;
          ignore = {
            code_background = true;
            sign = true;
          };
        };
        completions.blink.enabled = true;
        bullet.right_pad = 1;
        checkbox = {
          enabled = true;
          unchecked.icon = "▢ ";
          checked.icon = "✓ ";
          custom.todo.rendered = "◯ ";
          right_pad = 1;
        };
      };
    };

    utility.preview.markdownPreview = {
      enable = true;
      filetypes = [ "markdown" ];
    };

    luaConfigRC."markdown-extra" = lib.nvim.dag.entryAnywhere /* lua */ ''
      vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview" })
    '';
  };
}
