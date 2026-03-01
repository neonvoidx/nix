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
          # Imports ALL home manager modules except itself
          imports = builtins.attrValues (builtins.removeAttrs self.modules.homeManager [ "neonvoid" ]);
          # Or you can import module by module like so
          #         imports = [
          # self.modules.homeManager.common
          # self.modules.homeManager.packages
          # self.modules.homeManager.files
          # ....
          # ];

        };
    }
  ];
}
