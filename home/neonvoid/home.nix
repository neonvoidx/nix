{ ... }:
{
  imports = [
    ../common.nix
    ../configs/common/gtk.nix
    ../configs/linux
    ./packages.nix
    ./git-config.nix
    ./files.nix
  ];

  programs.bash.enable = true;
  services.playerctld.enable = true;
}
