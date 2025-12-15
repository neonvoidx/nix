{ pkgs, ... }:
{
  services = {
    udisks2.enable = true;
    flatpak.enable = true;
    hypridle.enable = true;
    gnome.gnome-keyring.enable = true;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    printing.enable = true;
    dbus.enable = true;
    dbus.packages = with pkgs; [ bluez ];
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  security.pam.services.gdm.enableGnomeKeyring = true;
}
