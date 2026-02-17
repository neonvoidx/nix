{
  lib,
  hostname ? "",
  ...
}:
let
  isVoid = hostname == "void";
  isVoidFrame = hostname == "voidframe";
in
{
  workspace = [
    "1,monitor:DP-2,default:true"
    "5,monitor:DP-2"
    "6,monitor:DP-2"
    "10,monitor:DP-2,name:steam"
    # Games, dont add decorations etc
    "11,name:gaming,monitor:DP-2,rounding:false,decorate:false,border:false,shadow:false"
    "2,monitor:DP-3"
    "4,monitor:DP-3"
    "3,monitor:HDMI-A-1"
  ];
}
