{ pkgs, ... }:
{
  xdg.desktopEntries.wowup-cf-uri-handler = {
    name = "WowUp-CF";
    comment = "Handle CurseForge protocol links";
    exec = "wowup-cf %u";
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/curseforge" ];
    icon = "wowup-cf";
  };
}
