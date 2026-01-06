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
    # mime.enable = true;
    # mimeApps = {
    #   enable = true;
    #   defaultApplications = { };
    # };
  };
}
