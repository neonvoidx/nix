{ ... }:
{
  flake.modules.nixos.xdg =
    { pkgs, ... }:
    {
      xdg = {
        portal = {
          enable = true;
          xdgOpenUsePortal = true;
          extraPortals = with pkgs; [
            xdg-desktop-portal
            xdg-desktop-portal-gtk
          ];
        };
      };
    };
}
