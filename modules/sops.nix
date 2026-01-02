{ config, lib, ... }:
{
  # sops-nix configuration at system level
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/home/neonvoid/.config/sops/age/keys.txt";

    secrets = {
      proton-bridge-password = {
        owner = "neonvoid";
      };
      gmail-app-password = {
        owner = "neonvoid";
      };
    };
  };
}
