{ config, ... }:
{
  flake.modules.nixos.sops = {
    sops = {
      defaultSopsFile = ../secrets/secrets.yaml;
      age.sshKeyPaths = [ "/home/neonvoid/.ssh/id_ed25519" ];
      validateSopsFiles = false;

      secrets = {
        # gmail-app-password = {
        #   owner = "neonvoid";
        # };
      };
    };
  };
}
