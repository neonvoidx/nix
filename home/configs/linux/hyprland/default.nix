{ inputs, pkgs, lib, ... }:
let
  # Import all the modular configuration files
  envVars = import ./environment.nix { inherit lib; };
  monitors = import ./monitors.nix { inherit lib; };
  keybindings = import ./keybindings.nix { inherit lib; };
  windowRules = import ./window-rules.nix { inherit lib; };
  settings = import ./settings.nix { inherit lib; };
  startup = import ./startup.nix { inherit lib; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings = lib.mkMerge [
      envVars
      monitors
      keybindings
      windowRules
      settings
      startup
    ];

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
}
