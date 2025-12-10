{ config, pkgs, ... }:

{
  home.username = "neonvoid";
  home.homeDirectory = "/home/neonvoid";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".zshrc".source = ./dots/.zshrc;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  xresources.properties = { "Xcursor.size" = 24; };

  # Packages that should be installed to the user profile.
  # home.packages = with pkgs; [ ];

  programs.git = { enable = true; };
  programs.bash = { enable = true; };

  home.stateVersion = "25.11";
}
