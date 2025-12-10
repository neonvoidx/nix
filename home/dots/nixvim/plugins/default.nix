{
  # Main plugins configuration
  # This file imports all plugin configurations
  
  imports = [
    ./lsp.nix
    ./completion.nix
    ./treesitter.nix
    ./ui.nix
    ./editing.nix
    ./git.nix
    ./utilities.nix
    ./markdown.nix
    ./formatting.nix
    ./kitty.nix
    ./ai.nix
  ];
}
