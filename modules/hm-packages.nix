{ config, ... }:
{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      home-manager
      kitty-themes
      godot
      godotPackages.export-template
      proton-pass-cli
      ffmpeg
    ];
  };
}
