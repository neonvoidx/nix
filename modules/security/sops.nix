{ ... }:
{
  den.aspects.sops.nixos = {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      age.sshKeyPaths = [ "/home/neonvoid/.ssh/id_ed25519" ];
      validateSopsFiles = false;

      secrets = { };
    };
  };
}
