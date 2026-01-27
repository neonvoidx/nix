{ config, ... }:
{
  flake.modules.nixos.desktop-services = { pkgs, ... }: {
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
          {
            name = "vesktop";
            type = "LowLatency_RT";
          }
          {
            name = "Discord";
            type = "LowLatency_RT";
          }
          {
            name = "pipewire";
            type = "LowLatency_RT";
          }
          {
            name = "pipewire-pulse";
            type = "LowLatency_RT";
          }
          {
            name = "wireplumber";
            type = "LowLatency_RT";
          }
        ];
      };
      printing = {
        enable = true;
        drivers = with pkgs; [ hplipWithPlugin ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      dbus.enable = true;
      dbus.packages = with pkgs; [ bluez ];
      libinput.enable = true;
      power-profiles-daemon.enable = true;
      upower.enable = true;
      gvfs.enable = true;
    };

    security.pam = {
      services = {
        greetd.enableGnomeKeyring = true;
        login.enableGnomeKeyring = true;
      };
      loginLimits = [
        {
          domain = "@audio";
          type = "-";
          item = "rtprio";
          value = "95";
        }
        {
          domain = "@audio";
          type = "-";
          item = "memlock";
          value = "unlimited";
        }
      ];
    };
  };
}
