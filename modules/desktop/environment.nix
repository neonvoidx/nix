{ den, ... }:
{
  den.aspects.de.nixos = {
    programs.dconf.enable = true;
    environment.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
