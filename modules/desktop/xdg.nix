{ pkgs, ... }:
{
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
        # Images
        "image/png" = "oculante.desktop";
        "image/jpeg" = "oculante.desktop";
        "image/jpg" = "oculante.desktop";
        "image/gif" = "oculante.desktop";
        "image/webp" = "oculante.desktop";
        "image/bmp" = "oculante.desktop";
        "image/tiff" = "oculante.desktop";
        "image/svg+xml" = "oculante.desktop";

        # PDFs and documents
        "application/pdf" = "okular.desktop";

        # Web browser
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";

        # Text files
        "text/plain" = "nvim.desktop";
        "text/markdown" = "nvim.desktop";

        # Videos
        "video/mp4" = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/webm" = "mpv.desktop";
        "video/mpeg" = "mpv.desktop";
        "video/x-msvideo" = "mpv.desktop";
        "video/quicktime" = "mpv.desktop";
        "video/x-flv" = "mpv.desktop";

        # Audio
        "audio/mpeg" = "mpv.desktop";
        "audio/mp4" = "mpv.desktop";
        "audio/x-wav" = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/ogg" = "mpv.desktop";
        "audio/x-vorbis+ogg" = "mpv.desktop";
        "audio/x-opus+ogg" = "mpv.desktop";

        # Archives
        "application/zip" = "org.gnome.FileRoller.desktop";
        "application/x-tar" = "org.gnome.FileRoller.desktop";
        "application/x-gzip" = "org.gnome.FileRoller.desktop";
        "application/x-bzip2" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rar" = "org.gnome.FileRoller.desktop";
      };
    };
  };
}
