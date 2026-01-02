{ config, lib, ... }:
{
  # sops-nix configuration at system level
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/home/neonvoid/.ssh/id_ed25519" ];
    # Don't fail if key doesn't exist (e.g., when Synology is unmounted)
    validateSopsFiles = false;

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
