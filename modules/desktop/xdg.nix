{ den, ... }:
{
  den.aspects.xdg.nixos =
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
