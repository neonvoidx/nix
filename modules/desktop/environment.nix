{ ... }:
{
  den.aspects.desktop-environment.nixos = {
    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";
      MANGOHUD_CONFIGFILE = "/home/neonvoid/.config/MangoHud/MangoHud.conf";
      MANGOHUD_CONFIG = "read_cfg";

      # Proton settings
      PROTON_ENABLE_WAYLAND = "1";
      PROTON_ENABLE_HDR = "1";
      PROTON_USE_NTSYNC = "1";
      PROTON_FSR4_UPGRADE = "1";
      PROTON_FSR4_RDNA3_UPGRADE = "1";
      PROTON_XESS_UPGRADE = "1";

      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
