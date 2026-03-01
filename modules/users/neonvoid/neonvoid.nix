{ self, lib, ... }:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "neonvoid" true)
    {
      nixos.neonvoid =
        { ... }:
        {
          users.users.neonvoid = {
            description = "NeonVoid";
            extraGroups = [
              "networkmanager"
              "audio"
              "video"
              "input"
              "libvirtd"
            ];
          };
        };

      homeManager.neonvoid =
        { ... }:
        {
          imports = builtins.attrValues (builtins.removeAttrs self.modules.homeManager [ "neonvoid" ]);
        };
    }
  ];
}
