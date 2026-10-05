{ den, inputs, ... }:
{
  den.aspects.scopebuddy = { host, ... }: {
    homeManager =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        # Mutable shell configs consume these at runtime rather than Nix interpolation.
        home.sessionVariables = {
          SCB_GAMES_LOCATION = host.gamesLocation or "${config.home.homeDirectory}/games";
          SCB_TIMEZONE = host.timezone;
        }
        // lib.optionalAttrs (host ? gpuVendorDeviceId) {
          SCB_GPU_DEVICE_ID = host.gpuVendorDeviceId;
        };

        home.packages = [
          inputs.scopebuddy.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];

        xdg.configFile."scopebuddy".source =
          config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.checkoutPath}/assets/scopebuddy";
      };
  };
}
