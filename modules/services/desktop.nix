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
      extraRules = [
        # Prevent Discord/Vesktop audio crackling during gaming
        {
          name = "vesktop";
          type = "LowLatency_RT";
        }
        {
          name = "Discord";
          type = "LowLatency_RT";
        }
      ];
    };
    printing.enable = true;
    dbus.enable = true;
    dbus.packages = with pkgs; [ bluez ];
    libinput.enable = true;
    power-profiles-daemon.enable = true;
    upower.enable = true;
    gvfs.enable = true;
  };

  security.pam.services.gdm.enableGnomeKeyring = true;
}
