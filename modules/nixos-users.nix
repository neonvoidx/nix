# NixOS module: User configuration
{ inputs, ... }:
{
  flake.modules.nixos.users = { pkgs, ... }: {
    users.users.neonvoid = {
      isNormalUser = true;
      description = "neonvoid";
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
