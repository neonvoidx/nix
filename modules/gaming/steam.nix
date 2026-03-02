{ ... }:
{
  den.aspects.steam.homeManager =
    {
      pkgs,
      inputs,
      osConfig ? null,
      ...
    }:
    let
      hostname = if osConfig != null then osConfig.networking.hostName or "" else "";
    in
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
