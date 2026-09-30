{ den, ... }:
{
  den.aspects.sudo.nixos =
    _:
    {
      # `nix.settings.trusted-users` contains `@wheel`, which historically
      # produced a NOPASSWD sudoers rule for wheel. Current nixpkgs derives
      # that rule solely from `wheelNeedsPassword`, so without this wheel would
      # be prompted for a password and a broken/missing PAM prompt locks out
      # all rebuilds.
      security.sudo.wheelNeedsPassword = false;
    };
}