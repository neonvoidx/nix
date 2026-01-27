{ config, ... }:
{
  flake.modules.nixos.xdg = { pkgs, ... }: {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
        ];
      };
      mime = {
        enable = true;
        defaultApplications = {
          "image/png" = "oculante.desktop";
          "image/jpeg" = "oculante.desktop";
          "image/jpg" = "oculante.desktop";
          "image/gif" = "oculante.desktop";
          "image/webp" = "oculante.desktop";
          "image/bmp" = "oculante.desktop";
          "image/tiff" = "oculante.desktop";
          "image/svg+xml" = "oculante.desktop";
          "application/pdf" = "okular.desktop";
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
          "text/plain" = "nvim.desktop";
          "text/markdown" = "nvim.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/mpeg" = "mpv.desktop";
          "video/x-msvideo" = "mpv.desktop";
          "video/quicktime" = "mpv.desktop";
          "video/x-flv" = "mpv.desktop";
          "audio/mpeg" = "mpv.desktop";
          "audio/mp4" = "mpv.desktop";
          "audio/x-wav" = "mpv.desktop";
          "audio/flac" = "mpv.desktop";
          "audio/ogg" = "mpv.desktop";
          "audio/x-vorbis+ogg" = "mpv.desktop";
          "audio/x-opus+ogg" = "mpv.desktop";
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/x-gzip" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
          "application/x-rar" = "org.gnome.FileRoller.desktop";
        };
      };
    };
  };
}
