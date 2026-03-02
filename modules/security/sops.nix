{ den, inputs, ... }:
{
  den.aspects.sops =
    { user, ... }:
    {
      nixos =
        { ... }:
        {
          imports = [ inputs.sops-nix.nixosModules.sops ];
          sops = {
            defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
            age.sshKeyPaths = [ "/home/${user.userName}/.ssh/id_ed25519" ];
            validateSopsFiles = false;
            secrets = { };
          };
        };
    };
}
