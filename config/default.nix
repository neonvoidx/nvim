{ ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./autocmds.nix
    ../plugins/colorscheme.nix
    ../plugins/bufferline.nix
    ../plugins/lualine.nix
    ../plugins/snacks.nix
    ../plugins/treesitter.nix
    ../plugins/lsp.nix
    ../plugins/completion.nix
    ../plugins/format.nix
    ../plugins/git.nix
    ../plugins/folds.nix
    ../plugins/editing.nix
    ../plugins/ui.nix
    ../plugins/markdown.nix
    ../plugins/navigation.nix
    ../plugins/session.nix
    ../plugins/kitty.nix
    ../plugins/nix-integration.nix
    ../plugins/ai.nix
  ];
}
