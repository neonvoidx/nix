{ ... }:
{
  flake.modules.homeManager.steam =
    {
      pkgs,
      inputs,
      hostname,
      ...
    }:
    {
      home.packages =
        with pkgs;
        [
          inputs.hytale-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.scopebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
          steam
          gamescope
          protontricks
          protonup-rs
          vulkan-tools
          sgdboop
        ]
        ++ pkgs.lib.optionals (hostname == "void") [
          deadlock-mod-manager
        ];
    };
}
