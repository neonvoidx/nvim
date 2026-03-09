{ ... }:
{
  plugins = {
    # hmts: Home Manager Template Strings – Nix-aware treesitter injections
    hmts.enable = true;

    # nil_ls LSP server for Nix (configured in lsp.nix via plugins.lsp.servers.nil_ls)
    # nixd LSP server is an alternative; nil_ls is already in lsp.nix
  };
}
