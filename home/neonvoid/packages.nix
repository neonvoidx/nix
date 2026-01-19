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
      (pkgs.callPackage ../../modules/programs/scopebuddy.nix { })
      (pkgs.callPackage ../../modules/programs/hyprshutdown.nix { })
      aseprite
      asciinema
      blueman
      cmatrix
      gamescope
      gimp
      github-copilot-cli
      gpu-screen-recorder
      grim
      gvfs
      hyprpicker
      hyprsysteminfo
      file-roller
      kdePackages.okular
      libsecret
      nix-versions.packages.${pkgs.stdenv.hostPlatform.system}.default
      oculante
      pinta
      protontricks
      protonup-rs
      prusa-slicer
      hyprpwcenter
      seahorse
      sgdboop
      slurp
      steam
      streamcontroller
      tenacity
      vulkan-tools
      wl-clipboard
      thunar
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ]
    ++ (
      if hostname == "void" then
        [
          deadlock-mod-manager
          inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
        ]
      else
        [ ]
    );
}
