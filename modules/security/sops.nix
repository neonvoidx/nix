{ den, inputs, ... }:
{
  den.aspects.sops =
    { host, ... }:
    {
      nixos =
        { ... }:
        {
          imports = [ inputs.sops-nix.nixosModules.sops ];
          sops = {
            defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
            age.sshKeyPaths = map (user: "/home/${user.userName}/.ssh/id_ed25519") (
              builtins.attrValues host.users
            );
            secrets = {
              "cachix" = {
                owner = "neonvoid";
                mode = "0400";
              };
              "github-pat" = {
                owner = "neonvoid";
                mode = "0400";
              };
            };
          };
        };
    };
}
