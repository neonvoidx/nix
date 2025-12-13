{
  osConfig ? null,
  ...
}:
let
  hostname = if osConfig != null then osConfig.networking.hostName or "" else "";
  isVoid = hostname == "void";
in
{
  services.flatpak = {
    enable = true;
    packages = if isVoid then [ "com.overwolf.CurseForge" ] else [ ];
  };
}
