{ inputs, ... }:
{
  flake.modules.homeManager.packages =
    {
      pkgs,
      osConfig ? null,
      ...
    }:
    let
      hostname = if osConfig != null then osConfig.networking.hostName else "";
    in
    {
      home.packages =
        with pkgs;
        [
          # Custom packages
          inputs.scopebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default

          # Standard packages
          appimage-run
          aseprite
          asciinema
          blueman
          cmatrix
          ffmpeg
          file-roller
          gamescope
          gimp
          github-copilot-cli
          godot
          godotPackages.export-template
          gpu-screen-recorder
          grim
          gvfs
          home-manager
          hyprpicker
          hyprpwcenter
          hyprshutdown
          hyprsysteminfo
          kdePackages.okular
          kitty-themes
          libsecret
          inputs.nix-versions.packages.${pkgs.stdenv.hostPlatform.system}.default
          oculante
          pinta
          proton-pass
          protontricks
          protonup-rs
          prusa-slicer
          seahorse
          sgdboop
          slurp
          steam
          streamcontroller
          tenacity
          thunar
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-volman
          vulkan-tools
          wl-clipboard
        ]
        ++ (
          if hostname == "void" then
            [
              deadlock-mod-manager
              inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
              noisetorch
            ]
          else
            [ ]
        );
    };
}
