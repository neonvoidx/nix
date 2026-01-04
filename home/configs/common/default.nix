{ ... }:
{
  imports = [
    ./colors.nix
    ./bat.nix
    ./btop.nix
    ./direnv.nix
    ./fastfetch.nix
    ./fzf.nix
    ./git.nix
    ./just.nix
    ./jq.nix
    ./kitty.nix
    ./lazygit.nix
    ./lsd.nix
    # ./nixvim  # Disabled in favor of nixcats
    ./nixcats.nix  # nixcats neovim configuration
    ./payrespects.nix
    ./tealdeer.nix
    ./tv.nix
    ./zoxide.nix
    ./zsh.nix
    ./yazi.nix
  ];
}
