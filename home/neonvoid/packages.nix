{
  pkgs,
  nix-versions,
  inputs,
  hostname,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # Custom packages
      (pkgs.callPackage ../../modules/programs/scopebuddy.nix { })
      (pkgs.callPackage ../../modules/programs/hyprshutdown.nix { })
      
      # Cross-platform tools
      home-manager
      kitty-themes
      ffmpeg
      proton-pass-cli
      
      # Development
      godot
      godotPackages.export-template
      
      # Graphics & Media
      aseprite
      gimp
      oculante
      pinta
      tenacity
      asciinema
      cmatrix
      
      # Gaming
      gamescope
      gpu-screen-recorder
      protontricks
      protonup-rs
      sgdboop
      steam
      vulkan-tools
      
      # Desktop utilities
      blueman
      file-roller
      grim
      gvfs
      hyprpicker
      hyprsysteminfo
      hyprpwcenter
      kdePackages.okular
      libsecret
      seahorse
      slurp
      streamcontroller
      thunar
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
      wl-clipboard
      
      # Development tools
      github-copilot-cli
      nix-versions.packages.${pkgs.stdenv.hostPlatform.system}.default
      prusa-slicer
    ]
    ++ (
      if hostname == "void" then
        [
          deadlock-mod-manager
          inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
          noisetorch
          xivlauncher
        ]
      else
        [ ]
    );
}
