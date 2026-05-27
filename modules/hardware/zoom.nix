{ den, inputs, ... }:
{
  den.aspects.zoom =
    { host, ... }:
    {
      nixos =
        { ... }:
        {
          imports = [ inputs.zoom-sync.nixosModules.default ];
          services.zoom-sync = {
            enable = true;
            user = builtins.head (builtins.attrNames host.users);
            # TODO extraArgs?
          };
        };
    };
}
