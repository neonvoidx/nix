{ self, ... }:
{
  config.flake.factory.user = username: isAdmin: {
    nixos."${username}" =
      { lib, pkgs, ... }:
      {
        users.users."${username}" = {
          isNormalUser = true;
          home = "/home/${username}";
          shell = pkgs.zsh;
          extraGroups = lib.optionals isAdmin [ "wheel" ];
        };
        programs.zsh.enable = true;

        # Factory auto-wires HM user — host only needs to import nixos.${username}
        home-manager.users."${username}" = {
          imports = [ self.modules.homeManager."${username}" ];
        };
      };

    homeManager."${username}" = {
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
    };
  };
}
