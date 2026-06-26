{ den, ... }:
{
  den.aspects.thunar = {
    nixos =
      { pkgs, ... }:
      {
        programs.thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-archive-plugin
            thunar-dropbox-plugin
            thunar-media-tags-plugin
            thunar-volman
          ];
        };
        services.tumbler.enable = true;
      };

    homeManager =
      { pkgs, ... }:
      {
        xdg.mimeApps = {
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
            "application/pdf" = "okularApplication_pdf.desktop";

            # Web browser
            "text/html" = "firefox.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
            "x-scheme-handler/about" = "firefox.desktop";
            "x-scheme-handler/unknown" = "firefox.desktop";

            # Text files
            "text/plain" = "nvim.desktop";
            "text/markdown" = "nvim.desktop";
            "text/x-shellscript" = "nvim.desktop";
            "text/x-python" = "nvim.desktop";
            "text/x-csrc" = "nvim.desktop";
            "text/x-c++src" = "nvim.desktop";
            "text/x-java" = "nvim.desktop";
            "text/javascript" = "nvim.desktop";
            "application/javascript" = "nvim.desktop";
            "text/css" = "nvim.desktop";
            "application/json" = "nvim.desktop";
            "application/xml" = "nvim.desktop";
            "text/xml" = "nvim.desktop";
            "text/x-yaml" = "nvim.desktop";
            "application/x-yaml" = "nvim.desktop";
            "text/x-rust" = "nvim.desktop";
            "text/x-go" = "nvim.desktop";
            "application/x-shellscript" = "nvim.desktop";
            "text/x-lua" = "nvim.desktop";
            "text/x-makefile" = "nvim.desktop";
            "text/x-log" = "nvim.desktop";
            "application/toml" = "nvim.desktop";
            "text/x-nix" = "nvim.desktop";

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

            # File manager
            "inode/directory" = "thunar.desktop";
          };
        };

        dconf.settings = {
          "org/gtk/settings/file-chooser" = {
            show-hidden = true;
          };
        };

        xfconf.settings = {
          xfce4-terminal = {
            "terminal/emulator" = "kitty";
          };
        };

        xdg.configFile."Thunar/uca.xml".text = ''
          <?xml version="1.0" encoding="UTF-8"?>
          <actions>
            <action>
              <icon>utilities-terminal</icon>
              <name>Open Terminal Here</name>
              <command>kitty --working-directory %f</command>
              <description>Open kitty terminal in the current directory</description>
              <patterns>*</patterns>
              <startup-notify/>
              <directories/>
            </action>
            <action>
              <icon>printer</icon>
              <name>Print</name>
              <command>bash %h/scripts/print-files.sh %F</command>
              <description>Print selected file(s) using a GTK printer dialog</description>
              <patterns>*</patterns>
              <other-files/>
            </action>
          </actions>
        '';

        home.packages = with pkgs; [
          xfce4-exo
        ];

        xdg.configFile."xfce4/helpers.rc".text = ''
          TerminalEmulator=kitty
        '';

        xdg.dataFile."applications/nvim.desktop".text = ''
          [Desktop Entry]
          Name=Neovim
          Exec=kitty -e nvim %F
          Terminal=false
          Type=Application
          Keywords=Text;editor;
          Icon=nvim
          Categories=Utility;TextEditor;
          StartupNotify=false
        '';
      };
  };
}
