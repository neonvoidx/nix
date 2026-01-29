{ hostname, ... }:
{
  imports = [
    ./bat.nix
    ./btop.nix
    ./cava.nix
    ./clipboard.nix
    ./cursor.nix
    ./direnv.nix
    ./easyeffects.nix
    ./email.nix
    ./fastfetch.nix
    ./firefox.nix
    ./flatpak.nix
    ./fzf.nix
    ./ghostty.nix
    ./git.nix
    ./gnome-keyring.nix
    ./gtk.nix
    ./hyprland
    ./hypridle.nix
    ./hyprpolkitagent.nix
    ./hyprshot.nix
    ./jq.nix
    ./just.nix
    ./kitty.nix
    ./lazygit.nix
    ./lsd.nix
    ./mangohud.nix
    ./mpv.nix
    ./nh.nix
    ./nixcats.nix
    ./noctalia.nix
    ./noisetorch.nix
    ./obs-studio.nix
    ./payrespects.nix
    ./pics.nix
    ./spicetify.nix
    ./stylix.nix
    ./tealdeer.nix
    ./thunar.nix
    ./tv.nix
    ./vesktop.nix
    ./yazi.nix
    ./zoxide.nix
    ./zsh.nix
  ]
  ++ (
    if hostname == "void" then
      [
        ./curseforge.nix
        # ./wowup-cf.nix
      ]
    else
      [ ]
  );
}
