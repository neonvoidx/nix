{ ... }:
{
  # NixOS: enable hyprland compositor system-wide
  flake.modules.nixos.hyprland = {
    programs.hyprland.enable = true;
  };

  flake.modules.homeManager.hyprland =
    {
      inputs,
      pkgs,
      lib,
      config,
      hostname,
      ...
    }:
    let
      envVars = import ./_data/environment.nix { inherit lib config; };
      monitors = import ./_data/monitors.nix { inherit lib config hostname; };
      keybindings = import ./_data/keybindings.nix { inherit lib config; };
      windowRules = import ./_data/windowrules.nix { inherit lib config hostname; };
      settings = import ./_data/settings.nix { inherit lib config hostname; };
      startup = import ./_data/startup.nix { inherit lib config hostname; };
      workspace = import ./_data/workspace.nix { inherit lib config hostname; };
      layerrule = import ./_data/layerrule.nix { inherit lib config hostname; };
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
          workspace
          layerrule
        ];

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
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/xdph.conf";
      home.file.".config/hypr/scripts".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/scripts";
      home.file.".config/hypr/hyprland/monitors".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/assets/hypr/hyprland/monitors";
    };
}
