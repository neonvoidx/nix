{ lib, ... }:
{
  stylix.targets = {
    cava.rainbow.enable = true;
    firefox.enable = false; # eldritch in master
    hyprland.enable = false; # hyprland already setup as wanted
    kitty.enable = false; # eldritch in master
    neovim.enable = false; # eldritch in master
    nixvim.enable = false;
    noctalia-shell.enable = false; # eldritch in master
    obsidian.enable = false; # eldritch in master
    yazi.enable = false; # follows terminal theme
    spicetify.enable = false; # already setup with Sleek theme and eldritch
    qt = {
      platform = lib.mkForce "gnome";
      standardDialogs = "xdgdesktopportal";
    };
  };
}
