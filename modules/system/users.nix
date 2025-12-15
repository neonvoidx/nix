{ pkgs, username, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "sambashare"
      "video"
      "plugdev"
      "input"
      "bluetooth"
    ];
    shell = pkgs.zsh;
  };
}
