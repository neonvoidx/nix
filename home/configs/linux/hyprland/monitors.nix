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
  monitor = [
    ",preferred,auto,1"
  ]
  ++ lib.optionals isVoid [
    "DP-2,3440x1440@143.92,4880x1440,1.0"
    "DP-3,3440x1440@143.92,4880x0,1.0"
    "HDMI-A-1,2560x1440@59.95,3440x727,1.0,transform,1"
  ]
  ++ lib.optionals isVoidFrame [
    "eDP-1,2880x1920@120,0x0,1.33333"
  ];

  workspace = lib.optionals isVoid [
    "3,monitor:HDMI-A-1,default:true,layoutopt:orientation:top"
    "1,monitor:DP-2,default:true"
    "5,monitor:DP-2,default:true"
    "10,monitor:DP-2,default:true"
    "11,monitor:DP-2,default:true"
    "2,monitor:DP-3,default:true"
    "4,monitor:DP-3,default:true"
  ];

}
