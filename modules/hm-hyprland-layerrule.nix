{ config, ... }:
{
  flake.modules.homeManager.hyprland-layerrule = {
  lib,
  hostname ? "",
  ...
}:
let
  isVoid = hostname == "void";
  isVoidFrame = hostname == "voidframe";
in
{
  layerrule = [
    {
      name = "noctaliahide";
      "match:namespace" = "^noctalia-notifications.*$";
      no_screen_share = "on";
    }
  ];
};
}
