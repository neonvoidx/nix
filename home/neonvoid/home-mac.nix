{ username, lib, ... }:
{
  imports = [
    ../common.nix
    ../configs/mac
    ./packages.nix
    ./git.nix
    ./files.nix
  ];

  # Override homeDirectory for macOS
  home.homeDirectory = lib.mkForce "/Users/${username}";
}
