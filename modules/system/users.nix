{ den, ... }:
{
  # NOTE: This aspect exists purely so that den.aspects.users resolves as a valid reference in the host includes
  # Essentially an empty constructor
  den.aspects.users.nixos = { ... }: { };
}
