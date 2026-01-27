{ config, ... }:
{
  flake.modules.nixos.users = { pkgs, username, ... }: {
    users.users.${username} = {
      isNormalUser = true;
      description = username;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "sambashare"
        "video"
        "plugdev"
        "input"
        "bluetooth"
      ];
      shell = pkgs.zsh;
    };
  };
}
