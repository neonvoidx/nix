{ inputs, ... }:
{
  flake.modules.nixos.sops =
    { inputs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        age.sshKeyPaths = [ "/home/neonvoid/.ssh/id_ed25519" ];
        validateSopsFiles = false;

        secrets = {
          # Define secrets here as needed
          # example = {
          #   owner = "neonvoid";
          # };
        };
      };
    };
}
