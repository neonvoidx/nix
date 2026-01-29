{ ... }:
{
  imports = [
    ../common.nix
    ../configs
    ./packages.nix
    ./git.nix
    ./files.nix
  ];

  programs.bash.enable = true;
  services = {
    udiskie.enable = true;
    playerctld.enable = true;
    xembed-sni-proxy.enable = true;
  };
}
