{ hostname, ... }:
{
  imports = [
    ./cava.nix
    ./clipboard.nix
    ./cursor.nix
    ./easyeffects.nix
    ./email.nix
    ./firefox.nix
    ./flatpak.nix
    ./gnome-keyring.nix
    ./gtk.nix
    ./hyprland
    ./hypridle.nix
    ./hyprpolkitagent.nix
    ./hyprshot.nix
    ./mangohud.nix
    ./mpv.nix
    ./nh.nix
    ./noctalia.nix
    ./noisetorch.nix
    ./obs-studio.nix
    ./pics.nix
    ./spicetify.nix
    ./thunar.nix
    ./vesktop.nix
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
