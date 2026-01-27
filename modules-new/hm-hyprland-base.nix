{ config, ... }:
{
  flake.modules.homeManager.hyprland-base = { inputs, pkgs, lib, config, hostname, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;

      settings = { };

      #TODO can we have submaps in keybindings.nix?
      extraConfig = # hyprlang
        ''
          # Resize submap bindings
          submap=resize
          binde=,right,resizeactive,20 0
          binde=,left,resizeactive,-20 0
          binde=,up,resizeactive,0 -20
          binde=,down,resizeactive,0 20
          binde=,l,resizeactive,20 0
          binde=,h,resizeactive,-20 0
          binde=,k,resizeactive,0 -20
          binde=,j,resizeactive,0 20
          bind=,escape,submap,reset
          submap=reset
        '';
    };

    # Portal package configuration
    xdg.portal = {
      extraPortals = [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
      config = {
        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
    };

    # Hyprland configuration files
    home.file.".config/hypr/xdph.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/hypr/xdph.conf";
    home.file.".config/hypr/scripts".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/hypr/scripts";
    home.file.".config/hypr/hyprland/monitors".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/linux/hypr/hyprland/monitors";
  };
}
