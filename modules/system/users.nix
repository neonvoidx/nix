{ ... }:
{
  # Individual users are defined in modules/users/
  flake.modules.nixos.user-accounts =
    { ... }:
    {
      # Global user defaults can go here if needed
    };
}
