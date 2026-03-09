{ ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
    ../plugins/lualine.nix
    ../plugins/colorscheme.nix
    ../plugins/bufferline.nix
    ../plugins/snacks.nix
    ../plugins/ui.nix
    ../plugins/completion.nix
    ../plugins/lsp.nix
    ../plugins/treesitter.nix
    ../plugins/format.nix
    ../plugins/git.nix
    ../plugins/folds.nix
    ../plugins/editing.nix
    ../plugins/markdown.nix
    ../plugins/navigation.nix
    ../plugins/session.nix
    ../plugins/ai.nix
    ../plugins/kitty.nix
    ../plugins/nix-integration.nix
  ];
}
