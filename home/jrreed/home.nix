{
  pkgs,
  username,
  lib,
  ...
}:
{
  imports = [ ../common.nix ];

  home = {
    inherit username;
    homeDirectory = lib.mkForce "/Users/${username}";
  };
  programs.git = {
    settings.user = {
      name = "jrreed";
      email = "jacob.reed@oracle.com";
    };
  };
}
