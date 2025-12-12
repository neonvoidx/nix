{ ... }:
{
  imports = [
    ../common.nix
    ../configs/linux
    ./packages.nix
    ./git.nix
    ./files.nix
  ];

  programs.bash.enable = true;
  services = {
    udiskie.enable = true;
    playerctld.enable = true;
  };
}
