# Exposes flake apps for building each host with nh.
# e.g. `nix run .#void` or `nix run .#voidframe`
{ den, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = den.lib.nh.denPackages { fromFlake = true; } pkgs;
    };
}
