{
  username,
  lib,
  ...
}:
{
  imports = [
    ../common.nix
    ../configs/mac
  ];

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
